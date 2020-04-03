class User < ApplicationRecord
  attr_accessor :remember_token # L9.3: 仮想属性
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
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true # L10.13: allow_nil

  
  # 8.21: fixture向けのdigestメソッドを追加する
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # L9.2: トークン生成用メソッドを追加する
  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # L9.3: 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token # クラスメソッドでトークン生成
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # L9.6: 渡されたトークンがダイジェストと一致したらtrueを返す
  # (L9.3のattr_accessor :remember_tokenとは異なり、ローカル変数)
  def authenticated?(remember_token)
    # self.remember_digest と同じ。
    return false if remember_digest.nil? # L9.19: ダイジェストが存在しない場合に対応
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # L9.11: ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end
