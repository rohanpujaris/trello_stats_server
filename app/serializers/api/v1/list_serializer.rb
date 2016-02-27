module Api::V1
  class ListSerializer < ActiveModel::Serializer
    attributes :name, :category

    def category
      object.category_cd
    end
  end
end