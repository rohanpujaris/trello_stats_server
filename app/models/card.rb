class Card < ActiveRecord::Base
  belongs_to :list
  has_many :card_members
  has_many :members, through: :card_members
  has_many :card_sprints
  has_many :sprint, through: :card_sprints
end
