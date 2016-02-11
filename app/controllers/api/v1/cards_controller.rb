module Api::V1
  class CardsController < BaseApiController
    def index
      render json: Card.limit(CARDS_PER_PAGE).offset(get_page_offset)
        .includes(member_developers: :member),
        include: '**', each_serializer: Api::V1::CardSerializer
    end

    private

    def get_page_offset
      params[:page] ?  params[:page].to_i - 1  : 0
    end
  end
end
