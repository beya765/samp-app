module SessionsHelper
  # L8.14: 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id # id情報だけ渡す。
  end

  # L8.16: セッションに含まれる現在のユーザーを検索する
  def current_user
    # IDが無効な場合(ユーザーが存在しない場合)、nilが返る。
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # L8.18: ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    # メソッドを使って判定
    !current_user.nil?
  end

  # 8.29
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
