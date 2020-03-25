# frozen_string_literal: true

class Api::V1::ApiController < ActionController::API
    include DeviseTokenAuth::Concerns::SetUserByToken
    before_action :authenticate_api_v1_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :role])
    end
end
