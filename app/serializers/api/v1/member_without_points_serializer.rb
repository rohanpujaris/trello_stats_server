module Api::V1
  class MemberWithoutPointsSerializer < ActiveModel::Serializer
    attributes :id, :user_name, :full_name, :expected_points, :job_profile

    def job_profile
      object.job_profile_cd
    end
  end
end