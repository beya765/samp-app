class UserMailer < ApplicationMailer

  # L11.12: アカウント有効化リンクをメール送信する
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  # L12.7: パスワード再設定のリンクをメールで送信する
  def password_reset(user)
    @user = user
    mail to: @user.email, subject: "Password reset"
  end
end
