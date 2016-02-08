class Member < ActiveRecord::Base
  has_many :card_members
  has_many :cards, through: :card_members
  has_many :point_stats
  has_many :member_leaves, class_name: 'MemberLeave'

  as_enum :job_profile, developer: 0, tester: 1, others: 2

  class << self
    def save_member_to_db
      board.members.each do |trello_member|
        find_or_create_by(trello_id: trello_id) do |member|
          member.full_name = trello_member.full_name
          member.user_name = trello_member.username
        end
      end
    end
  end

  def point_stats
    points_hash = {expected_points: expected_points_for_current_sprint,
      doing: 0, in_qa: 0, qa_pass: 0, accepted: 0}
    card_members.current_sprint_cards.each do |cm|
      ['doing', 'in_qa', 'qa_pass', 'accepted'].each do |state|
        if cm.card.list.send("#{state}?")
          points_hash[state.to_sym] = cm.individuals_point
        end
      end
    end
    points_hash
  end

  def expected_points_for_current_sprint
    points = expected_points.to_i
    if points > 0
      points = points - Holiday.holidays_in_current_sprint - current_sprint_leaves
    end
    points
  end

  def current_sprint_leaves
    member_leaves.where("member_leaves.date": Sprint.current_sprint_date_range).count
  end
end
