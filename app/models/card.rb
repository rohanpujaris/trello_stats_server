class Card < ActiveRecord::Base
  belongs_to :sprint
  belongs_to :list
  has_many :card_members
  has_many :member_developers,
    -> { joins(:member).merge(Member.developers) },
    class_name: 'CardMember'
  has_many :assigned_developers,
    -> { merge(Member.developers) },
    through: :member_developers,
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

  class << self
  end

  def save_or_update_sprint(card_labels)
    sprint_label = card_labels.find {|l| l['name'].starts_with?('Sprint')}
    if sprint_label
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
    assign_default_points_per_member
  end

  def save_or_update_list_association(list_id)
    if list.nil?
      trello_list = Trello::List.find(list_id)
      create_list(trello_id: trello_list.id, name: trello_list.name)
    elsif list.trello_id  != list_id
      trello_list = Trello::List.find(list_id)
      list.update_attributes(trello_id: list_id)
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
      member_counts = card_members.count
      if member_counts == 1
        card_members.first.update_attributes(individuals_point: points)
      elsif member_counts > 1
        points_array = points_partion_array
        card_members.each_with_index do |cm, index|
          cm.update_attributes(individuals_point: points_array[index])
        end
      end
    end
  end

  # Divides points into perfect integer for number of members assigned to the same card
  # if 2 members are assigned to the card with 13 points it will written array [7, 6]
  def points_partion_array
    member_counts = card_members.count
    division = (0...member_counts).map {|i| points / member_counts }
    (0...points%member_counts).each {|i| division[0] += 1}
    division
  end
end
