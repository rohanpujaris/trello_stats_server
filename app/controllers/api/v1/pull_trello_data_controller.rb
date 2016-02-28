module Api::V1
  class PullTrelloDataController < BaseApiController
    def pull_all_data
      PullAllDataFromTrello.perform_later
      render json: {data: {}}
    end
  end
end