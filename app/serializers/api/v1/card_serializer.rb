module Api::V1
  class CardSerializer < ActiveModel::Serializer
    # embed :ids, embed_in_root: true
    attributes :id, :name, :points

    has_many :card_member_having_developer, key: 'card_members'
  end
end
