module Api::V1
  class MemberSerializer < ActiveModel::Serializer
    attributes :id, :full_name, :point_stats
  end
end