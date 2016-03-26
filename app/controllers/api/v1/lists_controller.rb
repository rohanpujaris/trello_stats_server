module Api::V1
  class ListsController < BaseApiController
    before_action -> { authenticate_role! [:team_lead, :admin] }, only: [:update]

    def index
      render json: List.order(category_cd: :asc,updated_at: :desc),
        each_serializer: Api::V1::ListSerializer,
        meta: { categories: List.categories_hash }
    end

    def update
      if params[:data][:attributes][:category].blank?
        params[:data][:attributes][:category] = nil
      end
      list = List.find(params[:data][:id])
      if list.update_attributes(list_params)
        render json: list, serializer: Api::V1::ListSerializer
      else
        render json: list.json_api_format_errors, status: 422
      end
    end

    private

    def list_params
      params.require(:data).permit(attributes: [:category])
    end
  end
end
