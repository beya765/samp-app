class UserMailer < ApplicationMailer

  # L11.12: アカウント有効化リンクをメール送信する
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
