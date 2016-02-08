class CardMember < ActiveRecord::Base
  belongs_to :card
  belongs_to :member

  class << self
    def current_sprint_cards
      current_sprint_id = Sprint.current_sprint.id
      eager_load(card: [:sprint, :list])
        .where("sprints.id = #{current_sprint_id} AND card_members.individuals_point IS NOT NULL")
    end
  end
end
