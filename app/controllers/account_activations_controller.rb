class AccountActivationsController < ApplicationController
  # L11.31: アカウントを有効化するeditアクション
  def edit
    user = User.find_by(email: params[:email])
    # ユーザーが存在かつ、非有効化状態であり、有効化ダイジェストとリンクURL内のIDが一致するか
    if user && !user.activated? &&user.authenticated?(:activation, params[:id])
      user.activate # L11.37: ユーザーモデルオブジェクト経由でアカウントを有効化する
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
