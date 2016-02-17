module Api::V1
  class MemberWithoutPointsSerializer < ActiveModel::Serializer
    attributes :id, :user_name, :full_name, :expected_points
  end
end