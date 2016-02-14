class List < ActiveRecord::Base
  has_many :cards

  as_enum :category, doing: 0, in_qa: 1, qa_pass: 2, accepted: 3

  class << self
    def pull_lists
      RvTrello.lists.each do |trello_list|
        find_or_create_by(trello_id: trello_list.id) do |list|
          list.name = trello_list.name
        end
      end
    end

    List.categories.hash.each do |name, id|
      List.define_singleton_method(name) { find_by(category_cd: id) }
    end
  end
end
