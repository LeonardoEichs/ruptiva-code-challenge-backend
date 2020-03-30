# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    sign_up_keys = %i[first_name last_name email password role]
    devise_parameter_sanitizer.permit(:sign_up, keys: sign_up_keys)
  end
end
