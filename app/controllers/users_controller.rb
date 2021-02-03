class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!
    def show
    end

    def new
        @user = User.new
    end

    def edit
    end

    def create
        @user = User.new(user_params)

        respond_to do |format|
            if @user.save
                format.html { redirect_to @user, notice: "User was created successfully!" }
                format.json { render :show, status: :created, location: @user }
            else
                format.html { render :new, notice: "User failed to create!" }
                format.json { render json: @user.errors, status: :unprocessable_entity}
            end
        end
    end

    def update
        respond_to do |format|
            if @user.update(user_params)
                format.html { redirect_to @user, notice: "User was updated successfully!" }
                format.json { render :show, status: :created, location: @user }
            else
                format.html { render :edit, notice: "User failed to update!" }
                format.json { render json: @user.errors, status: :unprocessable_entity}
            end
        end
    end

    def destroy
        @user.destroy

        respond_to do |format|
            format.html { redirect_to @home, notice: "User was deleted successfully!" }
            format.json { render :show, status: :created, location: @user }
        end
    end

    private

    def  set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password)
    end
end