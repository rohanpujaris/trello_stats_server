class List < ActiveRecord::Base
  as_enum :category, doing: 0, in_qa: 1, qa_pass: 2, accepted: 3

  CATEGORY_DISPLAY_NAME = {
    "doing" => "Doing",
    "in_qa" => "In QA",
    "qa_pass" => "QA pass",
    "accepted" => "Accepted"
  }

  has_many :cards

  before_save :reset_previous_category

  categories.hash.each do |name, id|
    define_singleton_method(name) { find_by(category_cd: id) }
  end

  class << self
    def pull_lists
      RvTrello.lists.each do |trello_list|
        unless list = find_by(trello_id: trello_list.id)
          list = List.new(trello_id: trello_list.i)
        end
        list.name = trello_list.name
        list.save
      end

    end

    def categories_hash
      categories.hash.each_with_object({}) do |(name, id), acc|
        acc[CATEGORY_DISPLAY_NAME[name]] = id
      end
    end
  end

  private

  def reset_previous_category
    if category_cd_changed? && !category_cd.nil?
      List.where(category_cd: category_cd).update_all(category_cd: nil)
    end
  end
end
