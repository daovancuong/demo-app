module SessionHelper
  def log_in(user)
    session[:user_id]=user.id
  end

  def logged_in?
    current_user.nil? ? false : true
  end

  def current_user
    user_id=session[:user_id]
    if user_id
      @current_user=User.find_by(id: session[:user_id])
    elsif user_id=cookies.signed[:user_id]
      user=User.find_by(id: user_id)
      if user&&user.authenticated?("remember", cookies[:remember_token])
        @current_user=user
      end
    else
      @current_user

    end
  end

  def remember(user)
    user.remember
    log_in user
    cookies.permanent.signed[:user_id]=user.id
    cookies.permanent[:remember_token]=user.remember_token
  end

  def forget(user)
    user.forget

    cookies.delete(:user_id)
    cookies.delete(:remember)
    @current_user=nil
  end

  def correct_user?
    @current_user==User.find_by(id: params[:id])
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url]||default)
    session.delete(:forwarding_url)
  end

  def current_user?(user)
    current_user==user
  end

  def like?(user_id, micropost_id)
    !Like.find_by(user_id: user_id, micropost_id: micropost_id).nil?
  end

end
