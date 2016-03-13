module Api::V1
  class CardsController < BaseApiController
    def index
      cards = Card.limit(CARDS_PER_PAGE).offset(get_page_offset)
        .eager_load(:members, { card_member_having_developer: :member })
      if params[:search].present?
        cards = cards.name_like(params[:search])
      end
      cards = cards.apply_quick_filters(params[:quick_filters])
      cards = cards.filter_results(params.slice(*Card::FILTER_PARAMS))
      render json: cards, include: '**',
        each_serializer: Api::V1::CardSerializer,
        meta: { total_count: cards.count, filters: Card.filters }
    end

    private

    def get_page_offset
      params[:page] ?  params[:page].to_i - 1  : 0
    end
  end
end
