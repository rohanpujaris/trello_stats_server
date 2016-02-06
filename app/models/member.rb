class Member < ActiveRecord::Base
  has_many :card_members
  has_many :cards, through: :card_members
  has_many :point_stats

  def save_member_to_db
    board.members.each do |trello_member|
      find_or_create_by(trello_id: trello_id) do |member|
        member.full_name = trello_member.full_name
        member.user_name = trello_member.username
      end
    end
  end
end
