class MyAccountController < ApplicationController
    before_action :authenticate_user!

    def index
    end

    def tickets
    end
    
    def show
    end
end