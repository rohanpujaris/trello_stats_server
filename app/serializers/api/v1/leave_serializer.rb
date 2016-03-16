module Api::V1
  class LeaveSerializer < ActiveModel::Serializer
    attributes :id, :date

    belongs_to :member, serializer: Api::V1::MemberWithoutPointsSerializer
    belongs_to :creator, serializer: Api::V1::MemberWithoutPointsSerializer
  end
end
