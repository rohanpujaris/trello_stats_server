module Api::V1
  class CardMemberSerializer < ActiveModel::Serializer
    attributes :id, :individuals_point, :member_id, :card_id
  end
end