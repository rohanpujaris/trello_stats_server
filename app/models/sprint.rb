class Sprint < ActiveRecord::Base
  has_many :point_stats
  has_many :card_sprints
  has_many :cards, through: :card_sprints
end
