class Member < ActiveRecord::Base
  has_many :card_members
  has_many :cards, through: :card_members
  has_many :point_stats
end
