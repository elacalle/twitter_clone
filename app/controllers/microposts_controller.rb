class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(microposts_params)
    @micropost.image.attach(params[:micropost][:image])

    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'home/index'
    end
  end

  def destroy
    @micropost.destroy
    flash[:danger] = 'Micropost deleted'
    if request.referrer.nil? || request.referrer == micropost_url
      redirect_to root_url
    else
      redirect_to request.referrer
    end
  end

  private

  def microposts_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
