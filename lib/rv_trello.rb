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
          card = Card.find_or_create_by(trello_id: trello_card.id) do |card|
            card.name = trello_card.name
            card.list = List.find_or_create_by(trello_id: trello_card.list_id) do |list|
              trello_list = Trello::List.find(trello_card.list_id)
              list.name = trello_list.name
            end
          end
          card.save_or_update_sprint(trello_card.card_labels)
          card.name != trello_card.name && card.update_attributes(name: trello_card.name)
          card.save_or_update_list_association(trello_card.list_id)
          card.save_card_member_association(trello_card.member_ids)
        end
      end
    end
  end
end

# My member id 556ead174dcf67079fac60ed
# https://api.trello.com/1/members/556ead174dcf67079fac60ed/boards?key=511e8b6610964e5780f24f7427dff113&token=
# 568a6f94937d38515ebae567