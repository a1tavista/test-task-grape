module API
  module Version1
    module Defaults
      extend ActiveSupport::Concern
      included do
        prefix "api"
        version "v1", using: :path
        default_format :json
        format :json
        formatter :json, Grape::Formatter::ActiveModelSerializers

        helpers do
          def permitted_params
            @permitted_params ||= declared(params, include_missing: false)
          end

          def logger
            Rails.logger
          end

          def current_user
            @current_user ||= Account.authorize!(params[:access_token])
          end

          def authenticate!
            error!('401 Unauthorized', 401) unless current_user
          end
        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          error_response(message: e.message, status: 422)
        end

        rescue_from JWT::DecodeError do |e|
          error_response(message: e.message, status: 401)
        end

      end
    end
  end
end