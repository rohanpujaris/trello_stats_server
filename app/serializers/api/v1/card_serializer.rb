module Api::V1
  class CardSerializer < ActiveModel::Serializer
    # embed :ids, embed_in_root: true
    attributes :id, :name

    has_many :card_members
    has_many :assigned_developers, key: :members

    class MemberSerializer < ActiveModel::Serializer
      attributes :id, :user_name, :full_name
    end
  end
end
