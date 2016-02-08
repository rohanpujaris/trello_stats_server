class Sprint < ActiveRecord::Base
  has_one :sprint
  has_many :cards
  has_many :point_stats
  has_many :member_sprint_leaves
  # has_many :card_sprints
  # has_many :cards, through: :card_sprints

  class << self
    def save_sprints_to_db
      RvTrello.sprint_labels.each do |label|
        find_or_create_by(trello_id: label.id) do |sprint|
          sprint.name = label.name
        end
      end
    end

    def current_sprint
      where("DATE(?) BETWEEN start_date AND end_date", Date.today).first
    end

    def current_sprint_date_range
      sprint = current_sprint
      (sprint.start_date..sprint.end_date)
    end
  end
end
