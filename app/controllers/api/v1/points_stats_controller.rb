module Api::V1
  class PointStatsController < BaseApiController
    def referesh_point_stats
      RvTrello.pull_cards_from_trello
      render json: {data: {}}
    end
  end
end