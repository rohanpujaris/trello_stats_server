# TODO: Remove all methods which doesn't belongs here to a seprate module
# Example of methods to be moved: points_partion_array, get_points_from_name etc

class Card < ActiveRecord::Base
  FILTER_PARAMS = ['list_ids', 'sprint_ids', 'member_ids']

  belongs_to :sprint
  belongs_to :list
  has_many :card_members
  has_many :card_member_having_developer,
    -> { joins(:member).merge(Member.developers) },
    class_name: 'CardMember'
  has_many :assigned_developers,
    -> { merge(Member.developers) },
    through: :card_member_having_developer,
    source: 'member'
  has_many :members, through: :card_members
  # has_many :card_sprints
  # has_many :sprint, through: :card_sprints

  before_save do
    if new_record? || name_changed?
      self.points = get_points_from_name
    end
  end

  delegate :doing?, :in_qa?, :qa_pass?, :accepted?, to: :list

  scope :name_like, -> (term) { where('lower(name) like ?', "%#{term.downcase}%") }
  scope :list_id_equals, -> (list_ids) { where(list_id: list_ids) }
  scope :sprint_id_equals, -> (sprint_ids) { where(sprint_id: sprint_ids) }

  class << self
    def filters
      filters = {}
      filters[:lists] = List.select(:id, :name)
      filters[:sprints] = Sprint.select(:id, :name)
      filters[:members] = Member.select("id, full_name as name")
      filters
    end

    # This method doesn't belongs here. Find appropriate place
    def filter_results(cards, filters)
      filters.each do |filterType, filterIds|
        if filterType == 'list_ids'
          cards = cards.list_id_equals(filterIds)
        end
        if filterType == 'sprint_ids'
          cards = cards.sprint_id_equals(filterIds)
        end
        if filterType == 'member_ids'
          cards = cards.where("members.id IN (?)", filterIds)
        end
      end
      cards
    end

    def sync_with_trello_card(trello_card)
      card = Card.find_or_create_by(trello_id: trello_card.id) do |card|
        card.name = trello_card.name
        card.short_url = trello_card.short_url
        card.list = List.find_or_create_by(trello_id: trello_card.list_id) do |list|
          trello_list = Trello::List.find(trello_card.list_id)
          list.name = trello_list.name
        end
      end
      card.save_or_update_sprint(trello_card.card_labels)
      card.name != trello_card.name && card.update_attributes(name: trello_card.name)
      card.save_or_update_list_association(trello_card.list_id)
      card.save_card_member_association(trello_card.member_ids)
    end
  end

  def save_or_update_sprint(card_labels)
    if sprint_label = get_highest_number_sprint(card_labels)
      self.sprint = Sprint.find_or_create_by(trello_id: sprint_label['id']) do |s|
        s.name = sprint_label['name']
      end
      save
    end
  end

  def save_card_member_association(trello_member_ids)
    trello_member_ids.each do |member_id|
      member = Member.find_or_create_by(trello_id: member_id) do |m|
        trello_member = Trello::Member.find(member_id)
        m.full_name = trello_member.full_name
        m.user_name = trello_member.username
      end
      card_members.find_or_create_by(member_id: member.id)
    end
    self.reload
    assign_default_points_per_member unless points_manuallly_assigned?
  end

  def save_or_update_list_association(list_id)
    if list.nil?
      trello_list = Trello::List.find(list_id)
      create_list(trello_id: trello_list.id, name: trello_list.name)
    elsif list.trello_id  != list_id
      card_list = List.find_or_create_by(trello_id: list_id) do |l|
        trello_list = Trello::List.find(list_id)
        l.name = trello_list.name
      end
      update_attributes(list_id: card_list.id)
    end
  end

  def get_points_from_name
    # Select last occurence of substring in format '(13)'
    if index = name.rindex(/\(\d+\)/)
      point = name[index+1...-1]

      # Additional safety to avoid format like '(13)' in the card name
      # if '(13)' is in middle of card name then point.lenght will be definetly more then 2
      if point.length > 0 && point.length < 3
        point.to_i
      end
    end
  end

  # Assign almost equal points to each member added to the same card
  def assign_default_points_per_member
    if points
      card_member_having_developer = self.card_member_having_developer
      member_counts = card_member_having_developer.count
      if member_counts == 1
        cm = card_member_having_developer.first
        cm.auto_points_distribution = true
        cm.update_attributes(individuals_point: points)
      elsif member_counts > 1
        points_array = points_partion_array(member_counts)
        card_member_having_developer.each_with_index do |cm, index|
          cm.auto_points_distribution = true
          cm.update_attributes(individuals_point: points_array[index])
        end
      end
    end
  end

  # Divides points into perfect integer for number of members assigned to the same card
  # if 2 members are assigned to the card with 13 points it will written array [7, 6]
  def points_partion_array(member_counts)
    division = (0...member_counts).map {|i| points / member_counts }
    (0...points%member_counts).each {|i| division[0] += 1}
    division
  end

  def get_highest_number_sprint(card_labels)
    sprint_label = nil
    # if there are multiple sprint label per card, then select the sprint with biggest number
    # eg: If card A has label 'Sprint #13' and 'Sprint 14', then card will be considered
    # as Sprint #14 card
    card_labels.each do |l|
      if l['name'].starts_with?('Sprint')
        if sprint_label.nil? || l['name'][/\d+/].to_i > sprint_label['name'][/\d+/].to_i
          sprint_label =  l
        end
      end
    end
    sprint_label
  end
end
