module Api::V1
  class OnlyCardMemberSerializer < ActiveModel::Serializer
    attributes :id, :individuals_point
  end
end