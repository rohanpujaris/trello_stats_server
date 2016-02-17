module Api::V1
  class SprintsController < BaseApiController
    def index
      render json: Sprint.all,
        each_serializer: Api::V1::SprintSerializer
    end

    def update
      sprint = Sprint.find(params[:data][:id])
      if sprint.update_attributes(sprint_params)
        render json: sprint, serializer: Api::V1::SprintSerializer
      else
        render json: sprint.json_api_format_errors, status: 422
      end
    end

    private

    def sprint_params
      params.require(:data).permit(attributes: [:start_date, :end_date])
    end
  end
end