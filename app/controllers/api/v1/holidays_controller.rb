module Api::V1
  class HolidaysController < BaseApiController
    before_action -> { authenticate_role! [:admin] }, except: [:index]

    def index
      render json: Holiday.all,
        each_serializer: Api::V1::HolidaySerializer, include: '**'
    end

    def create
      if holiday = Holiday.create(holiday_params)
        render json: holiday, serializer: Api::V1::HolidaySerializer
      else
        render json: holiday.json_api_format_errors, status: 422
      end
    end

    def update
      holiday = Holiday.find(params[:data][:id])
      if holiday.update_attributes(holiday_params)
        render json: holiday, serializer: Api::V1::HolidaySerializer
      else
        render json: holiday.json_api_format_errors, status: 422
      end
    end

    def destroy
      holiday = Holiday.find(params[:id])
      if holiday.destroy
        render json: generate_msg_json('Holiday deletion successfull')
      else
        render json: generate_error_json('Something went wrong'), status: 422
      end
    end

    private

    def holiday_params
      params.require(:data).permit(attributes: [:id, :name, :date])
    end
  end
end
