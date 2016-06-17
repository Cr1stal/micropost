class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost = current_user.microposts.build # if signed_in?
      @image = @micropost.images.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def users
  end
end
