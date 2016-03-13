module Api::V1
  class LeaveSerializer < ActiveModel::Serializer
    attributes :id, :date

    belongs_to :member
    belongs_to :creator
  end
end
