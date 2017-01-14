class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
      @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc) # この行を追加
    end
  end

  def retweet
    original = Micropost.find(params[:id])
    @micropost = current_user.microposts.build(original_id: original.id)
    @micropost.content = "＃ #{original.user.name}さんのリツイート　\n #{original.content}"
    if @micropost.save
      flash[:success] = "Micropost retweet!"
      redirect_to current_user
    else
      redirect_to :back
    end
  end
  
  def destroy
    @micropost = current_user.microposts.find_by(id: params[:id])
    return redirect_to root_url if @micropost.nil?
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end
  
  private
  def micropost_params
    params.require(:micropost).permit(:content)
  end
end