class Card < ActiveRecord::Base
  belongs_to :list
  has_many :card_members
  has_many :members, through: :card_members
  has_many :card_sprints
  has_many :sprint, through: :card_sprints

  class << self
    def save_cards_to_db
      RvTrello.cards.each do |trello_card|
        card = find_or_create_by(trello_id: trello_card.id) do |card|
          card.name = trello_card.name
          card.list = List.find_or_create_by(trello_id: trello_card.list) do |list|
            list.name = trello_list.name
          end
        end
        card.save_card_member_association(trello_card.member_ids)
        card.save_list_association(trello_card.list_id)
      end
    end
  end

  def save_card_member_association(trello_member_ids)
    trello_member_ids.each do |member_id|
      member = Member.find_or_create_by(trello_id: member_id) do |m|
        trello_member = Trello::Member.find(member_id)
        m.full_name = trello_member.full_name
        m.user_name = trello_member.username
      end
      card.card_members.find_or_create_by(member_id: member.id)
    end
  end

  def save_list_association(list_id)
    if list.nil? || list.trello_id  != list_id
      trello_list = Trello::List.find(list_id)
      create_list(trello_id: trello_list.id, name: trello_list.name)
    end
  end
end
