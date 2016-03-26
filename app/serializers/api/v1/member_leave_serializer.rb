module Api::V1
  class MemberLeaveSerializer < ActiveModel::Serializer
    attributes :id, :user_name, :full_name

    has_many :leaves, serializer: Api::V1::LeaveSerializer
  end
end