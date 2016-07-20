class SessionController < ApplicationController
  def new
  end

  def create
    user=User.find_by(email: params[:session][:email])
    if user&&user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember]=='1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning]="Your account is not activated"
        redirect_to root_url
      end

    else
      flash[:danger]="Invalid email or password"
      render 'new'
    end

  end

  def destroy
    forget(current_user)
    session.delete(:user_id)
    redirect_to root_url
  end
end
