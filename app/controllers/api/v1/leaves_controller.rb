module Api::V1
  class LeavesController < BaseApiController
    def index
      leaves = current_user.admin_or_team_lead? ? Leave.all : current_user.leaves
      render json: leaves.includes(:member, :last_updated_by),
        each_serializer: Api::V1::LeaveSerializer, include: '**'
    end

    def create
      leave = if current_user.admin_or_team_lead?
        Leave.create(leave_params)
      else
        current_user.member.leaves.create(leave_params)
      end
      if leave.valid?
        render json: leave, serializer: Api::V1::LeaveSerializer
      else
        render json: leave.json_api_format_errors, status: 422
      end
    end

    def update
      leave = Leave.find(params[:data][:id])

      # TODO: add cancancan gem for handlin access control or refactor
      if !(current_user.admin_or_team_lead? || leave.member_id == current_user.member_id)
        render json: generate_error_json('Access Denied'), status: 401
      elsif leave.update_attributes(leave_params)
        render json: leave, serializer: Api::V1::LeaveSerializer
      else
        render json: leave.json_api_format_errors, status: 422
      end
    end

    def destroy
      leave = Leave.find(params[:id])

      # TODO: add cancancan gem for handlin access control or refactor
      if !(current_user.admin_or_team_lead? || leave.member_id == current_user.member_id)
        render json: generate_error_json('Access Denied'), status: 401
      elsif leave.destroy
        render json: generate_msg_json('Leave deletion successfull')
      else
        render json: generate_error_json('Something went wrong'), status: 422
      end
    end

    private

    def leave_params
      if current_user.admin_or_team_lead?
        permitted_params = params.require(:data).permit(
          attributes: [:id, :member_id, :date, :creator_id],
          relationships: {member: {data: [:id, :type]}}
        )
        permitted_params[:attributes].merge!(
          last_updated_by_id: current_user.member_id,
          member_id: params[:data][:relationships][:member][:data][:id]
        )
      else
         permitted_params = params.require(:data).permit(attributes: [:id, :date])
        permitted_params[:attributes].merge!(
          last_updated_by_id: current_user.member_id,
          member_id: current_user.member_id
        )
      end
    end
  end
end
