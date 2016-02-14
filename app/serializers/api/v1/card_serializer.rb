module Api::V1
  class CardSerializer < ActiveModel::Serializer
    # embed :ids, embed_in_root: true
    attributes :id, :name

    has_many :member_developers, key: 'card_members'
  end
end
