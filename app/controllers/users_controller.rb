class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  def show # 追加
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # ここを修正
    else
      render 'new'
    end
  end

  def edit
     @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Update Profile!"
      redirect_to @user # ここを修正
    else
      render 'edit'
    end
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path if @user != current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :location,
                                 :password_confirmation)
  end
end
