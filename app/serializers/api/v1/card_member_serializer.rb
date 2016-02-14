module Api::V1
  class CardMemberSerializer < ActiveModel::Serializer
    attributes :id, :individuals_point

    belongs_to :member

    class MemberSerializer < ActiveModel::Serializer
      attributes :id, :user_name, :full_name
    end
  end
end