module Api::V1
  class CardMembersController < BaseApiController
    def update
      card_member = CardMember.find(params[:data][:id])
      if card_member.update_attributes(card_members_params)
        render json: card_member, serializer: Api::V1::OnlyCardMemberSerializer
      else
        render json: card_member.json_api_format_errors, status: 422
      end
    end

    private

    def card_members_params
      params.require(:data).permit(attributes: :individuals_point)
    end
  end
end
