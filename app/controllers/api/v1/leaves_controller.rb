module Api::V1
  class LeavesController < BaseApiController
    def index
      render json: current_user.admin? ? Leave.all : current_user.leaves,
        each_serializer: Api::V1::LeaveSerializer, include: '**'
    end

    def create
      leave = if current_user.admin?
        Leave.create(leave_params)
      else
        current_user.leaves.create(leave_params)
      end
      if leaves.valid?
        render json: leave, serializer: Api::V1::LeaveSerializer
      else
        render json: leave.json_api_format_errors, status: 422
      end
    end

    def update
      leave = Leave.find(params[:data][:id])
      if !(current_user.admin? || leave.member_id == current_user.member_id)
        render json: generate_error_json('Access Denied'), status: 401
      elsif leave.update_attributes(leave_params)
        render json: sprint, serializer: Api::V1::LeaveSerializer
      else
        render json: sprint.json_api_format_errors, status: 422
      end
    end

    private

    def leave_params
      allowed_attribute = current_user.admin? ? [:id, :member_id, :date] : [:id, :date]
      params.require(:data).permit(attributes: allowed_attribute).merge!(addition_params)
    end

    def addition_params
      { creator_id: current_user.id }
    end
  end
end