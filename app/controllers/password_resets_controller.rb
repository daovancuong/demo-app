class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def get_user
    @user=User.find_by(email: params[:email])
  end

  def valid_user
    unless @user&& @user.authenticated?(:reset, params[:id])
      flash[:danger]="Invalid user"
      redirect_to root_url
    end
  end

  def new
  end

  def edit
#invoke here when user press the link

  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "cant be blank ")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:infor]="password has been reset"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirm)
  end
end
