module Api::V1
  # Check whether we can inherit from ActionController::Api instead of ApplicationController
  class BaseApiController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    protect_from_forgery

    before_action :authenticate_user!

    def record_not_found
      render nothing: true, status: :bad_request
    end

    def generate_error_json(*errors)
      errors = errors.map { |msg| { title: msg } }
      {errors: errors}
    end

    def generate_msg_json(message)
      generate_meta_json({message: message})
    end

    def generate_meta_json(hash)
      {meta: hash}
    end

    def authenticate_role!(roles)
      if roles.exclude?(current_user.role)
        render json: generate_error_json('Access Denied'), status: 401
      end
    end
  end
end