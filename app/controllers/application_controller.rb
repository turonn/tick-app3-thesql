class ApplicationController < ActionController::Base
    before_action :initialize_cart
    before_action :store_current_location, :unless => :devise_controller?

    private

    def initialize_cart
        session[:cart] ||= []
    end

    def store_current_location
        store_location_for(:user, request.url)
    end

end
