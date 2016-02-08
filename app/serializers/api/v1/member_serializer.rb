module Api::V1
  class MemberSerializer < ActiveModel::Serializer
    attributes :id, :user_name, :full_name, :point_stats
  end
end