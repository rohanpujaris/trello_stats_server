module Api::V1
  class MembersController < BaseApiController
    def index
      serializer = if params[:point_stats] == 'true'
        Api::V1::MemberSerializer
      else
        Api::V1::MemberWithoutPointsSerializer
      end
      render json: Member.developers, each_serializer: serializer
    end

    def update
      member = Member.find(params[:data][:id])
      if member.update_attributes(member_params)
        render json: member, serializer: Api::V1::MemberWithoutPointsSerializer
      else
        render json: member.json_api_format_errors, status: 422
      end
    end

    private

    def member_params
      params.require(:data).permit(attributes: [:full_name, :user_name, :expected_points])
    end
  end
end
