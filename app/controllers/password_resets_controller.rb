class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update] # L12.15
  before_action :valid_user, only: [:edit, :update] # L12.15
  # L12.16: パスワード再設定の有効期限チェック
  before_action :check_expiration, only: [:edit, :update] 

  def new
  end

  # L12.5: パスワード再設定用のcreateアクション
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  # L12.16: パスワード再設定のupdateアクション(views/password_resets/editのフォームから呼び出し)
  def update
    if params[:user][:password].empty? # password blank
      # L10.13(https://railstutorial.jp/chapters/updating_and_deleting_users?version=5.1#code-allow_blank_password)
      # 上記にてパスワードの空更新OKとしてしまっているため、
      # パスワードが空だった時のデフォルトのエラーメッセージ追加
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params) # update success
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit' # invalid password
    end
  end

  private
    # L12.16: パラメータを指定(不正パラメータ対策)
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # L12.15
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # L12.15: 正しいユーザーかどうか確認する
    def valid_user
      # 正当なユーザー(存在性、有効化、トークンの一致)でない場合、リダイレクトされる
      unless (@user && @user.activated? && 
          @user.authenticated?(:reset, params[:id]))
          redirect_to root_url
      end
    end

    # L12.16: トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
