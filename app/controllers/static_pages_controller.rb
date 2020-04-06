class StaticPagesController < ApplicationController
  def home
    # L13.40: homeアクションにマイクロポストのインスタンス変数を追加する
    # L13.47: homeアクションにフィードのインスタンス変数を追加する
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
