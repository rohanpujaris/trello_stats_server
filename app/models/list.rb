class List < ActiveRecord::Base
  has_many :cards

  class << self
    def save_lists_to_db
      RvTrello.lists.each do |trello_list|
        find_or_create_by(trello_id: trello_list.id) do |list|
          list.name = trello_list.name
        end
      end
    end
  end
end
