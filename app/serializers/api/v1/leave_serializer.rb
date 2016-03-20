module Api::V1
  class LeaveSerializer < ActiveModel::Serializer
    attributes :id, :date

    belongs_to :member, serializer: Api::V1::MemberWithoutPointsSerializer
    belongs_to :last_updated_by, serializer: Api::V1::MemberWithoutPointsSerializer
  end
end
