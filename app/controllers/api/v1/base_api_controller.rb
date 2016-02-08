module Api::V1
  class BaseApiController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    protect_from_forgery

    def record_not_found
      render nothing: true, status: :bad_request
    end
  end
end