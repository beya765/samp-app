class SessionsController < ApplicationController
  def new
  end

  def create
    # L8.7: ユーザーをデータベースから見つけて検証する
    user = User.find_by(email: params[:session][:email].downcase)
    # authenticateメソッド: has_secure_passwordが提供。認証失敗時、falseを返す。
    if user && user.authenticate(params[:session][:password])
      # L8.15: ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      redirect_to user # user_url(user)
    else
      # flash.now: その後リクエストが発生したときflashが消滅します
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new'
    end
  end

  def destroy
    # L8.30: セッションを破棄する (ユーザーのログアウト)
    log_out
    redirect_to root_url
  end
end
