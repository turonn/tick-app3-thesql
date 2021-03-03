class ApplicationController < ActionController::Base
  before_action :initialize_cart
  before_action :store_current_location, unless: :devise_controller?

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def initialize_cart
    session[:cart] ||= {}
  end

  def store_current_location
    store_location_for(:user, request.url)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :home_team_id, :email, :password, :password_confirmation)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :home_team_id, :email, :password, :password_confirmation, :current_password)
    end
  end
end
