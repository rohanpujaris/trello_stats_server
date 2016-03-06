module Api::V1
  class TrelloAuthController < BaseApiController
    # Below code are copied from 'devise_token_auth' gem.
    # Eventual goal is to remove this gem and just use part of the code from the gem

    skip_before_action :authenticate_user!, only: [:authenticate]

    def authenticate
      if params[:token]
        trello_user_info_uri = URI(trello_user_info_url)
        response = Net::HTTP.get_response(trello_user_info_uri)

        if response.code == "200"
          res_body = JSON.parse(response.body)

          # Do nothing if there is no member record present for the user
          # trying to authenticate
          unless member = Member.find_by(trello_id: res_body["idMember"])
            render json: generate_error_json("User not recognize"), status: 401
            return
          end

          user = User.find_or_initialize_by(uid: res_body["id"], provider: 'trello')

          unless user.id
            p = SecureRandom.urlsafe_base64(nil, false)
            user.password = p
            user.password_confirmation = p
            user.member_id = member.id
          end

          client_id = SecureRandom.urlsafe_base64(nil, false)
          token     = SecureRandom.urlsafe_base64(nil, false)

          user.tokens[client_id] = {
            token: BCrypt::Password.create(token),
            expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
          }
          user.skip_confirmation!
          sign_in(:user, user, store: false, bypass: false)
          user.save!

          render json: generate_meta_json({
            auth_headers: user.build_auth_header(token, client_id)
          })
        else
          render json: generate_error_json("Invalid token"), status: 401
        end
      else
        render json: generate_error_json("No token provided"), status: 400
      end
    end

    def logout
      user = remove_instance_variable(:@resource) if @resource
      client_id = remove_instance_variable(:@client_id) if @client_id
      remove_instance_variable(:@token) if @token

      if user and client_id and user.tokens[client_id]
        user.tokens.delete(client_id)
        user.save!
        render json: generate_msg_json("Logout sucessfull")
      else
        render json: generate_error_json("You are already logged out"), status: 400
      end
    end

    private

    def trello_user_info_url
      "https://api.trello.com/1/tokens/#{params[:token]}?key=#{TRELLO_PUBLIC_KEY}"
    end
  end
end
