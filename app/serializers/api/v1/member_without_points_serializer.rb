module Api::V1
  class MemberWithoutPointsSerializer < ActiveModel::Serializer
    attributes :id, :full_name, :expected_points, :job_profile, :role

    def job_profile
      object.job_profile_cd
    end

    def role
      object.role_cd
    end
  end
end
