module Api::V1
  class MembersController < BaseApiController
    def index
      render json: Member.developers, each_serializer: Api::V1::MemberSerializer
    end
  end
end
