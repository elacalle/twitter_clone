class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(allowed_params)

    if @user.save
      flash[:success] = "Welcome to Sample App!"

      redirect_to @user
    elsif
      render 'new'
    end
  end

  private

    def allowed_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end
end
