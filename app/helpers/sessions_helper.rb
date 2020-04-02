module SessionsHelper
  # L8.14: 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id # id情報だけ渡す。
  end

  # L9.8: ユーザーを記憶する
  def remember(user)
    user.remember # クラスメソッドでトークン生成し、ダイジェストへ保存
    # cookiesメソッドでユーザーIDと記憶トークンを永続cookiesへ保存
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # L9.9: 記憶トークンcookieに対応するユーザーを返す
  def current_user
    # ユーザーID(ローカル変数)に代入(ユーザーIDのセッションが存在)
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    # 一時セッションになければ、永続cookies(ユーザID)を代入
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      # ユーザーが存在かつ、永続cookies(記憶トークン)と一致でログイン処理
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  # # L8.16: セッションに含まれる現在のユーザーを検索する
  # # L9.9にて一時セッションしか扱っていない本メソッドを上記へ変更
  # def current_user
  #   # IDが無効な場合(ユーザーが存在しない場合)、nilが返る。
  #   if session[:user_id]
  #     @current_user ||= User.find_by(id: session[:user_id])
  #   end
  # end

  # L8.18: ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    # メソッドを使って判定
    !current_user.nil?
  end

  # L9.12: 永続的セッションを破棄する
  def forget(user)
    user.forget # クラスメソッドで記憶ダイジェストをnilに更新
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 8.29
  def log_out
    forget(current_user) # L9.12
    session.delete(:user_id)
    @current_user = nil
  end
end
