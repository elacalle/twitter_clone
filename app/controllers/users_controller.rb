class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = retrieve_user
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit
    @user = retrieve_user
  end

  def destroy
    if current_user.is_admin
      flash[:success] = 'User updated'
      User.find(params[:id]).destroy

      redirect_to users_url
    end
  end

  def update
    @user = retrieve_user

    if @user.update(allowed_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(allowed_params)

    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
    elsif
      render 'new'
    end
  end

  private

  def allowed_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def retrieve_user
    @user = User.find(params[:id])
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to login_url unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
