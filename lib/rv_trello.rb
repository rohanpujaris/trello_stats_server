class RvTrello
  REALVOLVE_BOARD_NAME = 'Realvolve-Sprint'

  class << self
    def board
      @board ||= Trello::Board.all.find {|t| t.name == REALVOLVE_BOARD_NAME }
    end

    def board_id
      @board_id ||= board.id
    end

    def members
      @members ||= board.members
    end

    def labels
      @labels ||= board.labels
    end

    def sprint_labels
      @sprint_labels ||= labels.select {|l| l.name.starts_with?('Sprint')}
    end

    def lists
      @lists ||= board.lists
    end

    def cards
      @cards ||= board.cards
    end

    def pull_data_from_trello
      cards = []
      success = ExceptionHandler.retry_if_expection { Sprint.pull_sprints }
      success = success && ExceptionHandler.retry_if_expection { List.pull_lists }
      success = success && ExceptionHandler.retry_if_expection { cards = RvTrello.cards }

      if success
        ExceptionHandler.retry_collection_from_offset(collection: cards) do |trello_card|
          Card.sync_with_trello_card(trello_card)
        end
      end
    end
  end
end

# My member id 556ead174dcf67079fac60ed
# https://api.trello.com/1/members/556ead174dcf67079fac60ed/boards?key=511e8b6610964e5780f24f7427dff113&token=
# 568a6f94937d38515ebae567