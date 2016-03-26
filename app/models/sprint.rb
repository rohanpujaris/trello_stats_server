class Sprint < ActiveRecord::Base
  SPRINT_DURATION = 10

  has_one :sprint
  has_many :cards
  has_many :point_stats
  # has_many :member_sprint_leaves
  # has_many :card_sprints
  # has_many :cards, through: :card_sprints

  default_scope { order(updated_at: :desc) }

  class << self
    def pull_sprints
      RvTrello.sprint_labels.each do |label|
        find_or_create_by(trello_id: label.id) do |sprint|
          sprint.name = label.name
        end
      end
    end

    def current_sprint
      # Pick sprint as current sprint if today's date falls between start_date and end_date of sprint
      current_sprint = where("DATE(?) BETWEEN start_date AND end_date", Date.today).first

      # If today's date does not falls under any sprint, pick sprint with greater end_date
      current_sprint ||= Sprint.reorder(end_date: :desc).where("end_date is not null").first

      # If there is no end_date set for any of the sprint then pick the last added sprint
      # as the current sprint
      current_sprint ||= Sprint.reorder(created_at: :desc).first
    end

    def current_sprint_date_range
      sprint = current_sprint
      (sprint.start_date..sprint.end_date)
    end

    def current_sprint_name
      current_sprint.name
    end
  end
end
