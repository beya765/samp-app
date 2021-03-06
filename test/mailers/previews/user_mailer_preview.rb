# Preview all emails at http://192.168.33.10:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at
  # http://192.168.33.10:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    # L11.18: アカウント有効化のプレビューメソッド (完成)
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at
  # http://192.168.33.10:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    # L12.10: パスワード再設定のプレビューメソッド (完成)
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end
end
