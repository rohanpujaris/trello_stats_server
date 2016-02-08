class PointStatsController < ApplicationController
  def index
    render json: Member.developers.to_json(methods: [:point_stats])
  end

  def referesh_point_stats
    RvTrello.pull_cards_from_trello
    render json: Member.developers.to_json(methods: [:point_stats])
  end
end
