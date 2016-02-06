class Sprint < ActiveRecord::Base
  has_many :point_stats
  has_many :card_sprints
  has_many :cards, through: :card_sprints

  class << self
    def save_sprints_to_db
      RvTrello.sprint_labels.each do |label|
        find_or_create_by(trello_id: label.id) do |sprint|
          sprint.name = label.name
        end
      end
    end
  end
end
