class SessionsController < ApplicationController
  def new
  end

  def create
    # L8.7: ユーザーをデータベースから見つけて検証する
    @user = User.find_by(email: params[:session][:email].downcase)
    # authenticateメソッド: has_secure_passwordが提供。認証失敗時、falseを返す。
    if @user && @user.authenticate(params[:session][:password])
      # L8.15: ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in @user
      # L9.7/9.23:  [remember me] チェックボックスによるユーザー保持(セッションヘルパー呼び出し)
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user # L10.32: フレンドリーフォワーディング
    else
      # flash.now: その後リクエストが発生したときflashが消滅します
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new'
    end
  end

  def destroy
    # L8.30: セッションを破棄する (ユーザーのログアウト)
    log_out if logged_in? # L9.16: ログイン中の場合のみログアウトする
    redirect_to root_url
  end
end
