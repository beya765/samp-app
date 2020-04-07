class RelationshipsController < ApplicationController
  before_action :logged_in_user # L14.32

  # L14.33
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    # L14.36: RelationshipsコントローラでAjaxリクエストに対応する
    respond_to do |format| # 下記のどちらか一つが実行される(非同期(Ajax)か、それ以外)
      format.html { redirect_to @user }
      # アクションと同じ名前を持つJavaScript用の埋め込みRuby(.js.erb)ファイル
      # (app/views/relationships内のcreate.js.erb)を呼び出す
      format.js
    end
  end

  # L14.33
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    # L14.36: RelationshipsコントローラでAjaxリクエストに対応する
    respond_to do |format| # 下記のどちらか一つが実行される(非同期(Ajax)か、それ以外)
      format.html { redirect_to @user }
      # アクションと同じ名前を持つJavaScript用の埋め込みRuby(.js.erb)ファイル
      # (app/views/relationships内のdestroy.js.erb)を呼び出す
      format.js
    end
  end
end
