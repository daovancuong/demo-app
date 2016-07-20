class AccountActivationsController < ApplicationController
  def create

  end

  def edit
    user =User.find_by(email: params[:email])
    if user &&!user.activated? && user.authenticated?(:active, params[:id])
      log_in user
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      flash[:success]="Activated success!"
      redirect_to user
    else
      flash[:danger]="Account is not activated"
      redirect_to root_url
    end
  end
end
