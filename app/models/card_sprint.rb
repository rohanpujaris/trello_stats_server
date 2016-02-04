class CardSprint < ActiveRecord::Base
  belongs_to :card
  belongs_to :sprint
end
