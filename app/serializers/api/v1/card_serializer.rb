module Api::V1
  class CardSerializer < ActiveModel::Serializer
    attributes :id, :name, :points, :short_url

    # If serializer is not specified it does not work well in roduction mode
    has_many :card_member_having_developer, key: 'card_members',
      serializer: Api::V1::CardMemberSerializer
  end
end
