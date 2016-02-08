module Api::V1
  class PointStatsController < BaseApiController
    def referesh_point_stats
      RvTrello.pull_cards_from_trello
      render json: Member.developers.to_json(
        only: [:id, :username, :full_name],
        methods: [:point_stats]
      )
    end
  end
end