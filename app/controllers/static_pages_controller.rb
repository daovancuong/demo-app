class StaticPagesController < ApplicationController
  def home
    @like=Like.new
    if logged_in?
      @micropost=current_user.microposts.build if logged_in?
      @feed_items = current_user.feed.paginate(page: params[:page]) if !current_user.nil?
    else
      redirect_to users_path
    end

  end

  def help
  end

  def about
  end

  def contact
  end
end
