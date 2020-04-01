class User < ApplicationRecord
  # L6.32: DB保存前にemail属性を小文字に変換
  before_save { email.downcase! }
  # L6.9: validatesメソッドにpresence: trueオプションハッシュを渡す。
  # メソッドの最期の引数としてハッシュを渡す場合、{}はなくてもいい
  validates :name, presence: true, length: { maximum: 50 }
  # L6.21: メールフォーマットの正規表現(https://railstutorial.jp/chapters/modeling_users?version=5.1#table-valid_email_regex)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  # L6.37: パスワードのハッシュ化など
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # 8.21: fixture向けのdigestメソッドを追加する
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
