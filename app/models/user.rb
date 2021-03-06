class User < ApplicationRecord
  # L13.11: ユーザーがマイクロポストを複数所有する(has_many)関連付け
  # L13.19: マイクロポストは、その所有者 (ユーザー) と一緒に破棄されることを保証する
  has_many :microposts, dependent: :destroy
  # L14.2: 能動的関係に対して1対多 (has_many) の関連付けを実装する
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  # L14.12: 受動的関係を使ってuser.followersを実装する
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  # L14.8: Userモデルにfollowingの関連付けを追加する(多対多)
  # Railsはfollowingのシンボルを見て、relationshipsテーブルのfollowed_idを使って対象のユーザーを取得
  # :sourceでfollowing配列の元はfollowed idの集合である」ということをRailsに伝えます。
  # (followedsという配列名は英語として不適切なためfollowingを使用)
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower # L14.12
  
  attr_accessor :remember_token, :activation_token, :reset_token # L9.3/11.3/L12.6: 仮想属性
  # ---L6.32: DB保存前にemail属性を小文字に変換
  # ---before_save { email.downcase! }
  before_save :downcase_email # L11.3: メソッド参照が推奨のため修正
  before_create :create_activation_digest # L11.3: Userオブジェクト作成前に呼び出される
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

  # L11.26の抽象化に伴い、修正(https://railstutorial.jp/chapters/account_activation?version=5.1#sec-generalizing_the_authenticated_method)
  # ---# L9.6: 渡されたトークンがダイジェストと一致したらtrueを返す
  # ---# (L9.3のattr_accessor :remember_tokenとは異なり、ローカル変数)
  # ---def authenticated?(remember_token)
  #   ---# self.remember_digest と同じ。
  #   ---return false if remember_digest.nil? # L9.19: ダイジェストが存在しない場合に対応
  #   ---BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # ---end

  # L11.26: トークンが抽象化(send)ダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    # sendメソッドに渡す引数(attribute: remember or activation)で処理を振り分け
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # L9.11: ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # L11.35: Userモデルにユーザー有効化メソッドを追加する

  # アカウントを有効化する
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now # app/mailer/user_mailerのメソッド
  end

  # L12.6: Userモデルにパスワード再設定用メソッドを追加する

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now # app/mailer/user_mailerのメソッド
  end

  # L12.17: パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    # パスワード再設定メールの送信時刻が、現在時刻より2時間以上前 (早い) の場合
    reset_sent_at < 2.hours.ago 
  end

  # ---L13.46: マイクロポストのステータスフィードを実装するための準備
  # ---L14.44: とりあえず動くフィードの実装
  # ---L14.46: whereメソッド内の変数に、キーと値のペアを使う
  # L14.47: フィードの最終的な実装
  # ユーザーのステータスフィードを返す(Staticコントローラーのhomeアクションで使用)
  def feed
    # L13.46---Micropost.where("user_id = ?", id) # L14.44にて削除

    # ---following_idsメソッド: has_many :followingの関連付けをしたときに
    # ---Active Recordが自動生成したもの。フォローしているユーザーidの文字列をDBから取得
    # ---User.first.following.map(&:id)のような形で取得したID群でDBからフォローユーザ達の
    # ---マイクロポストを取り出す。(DBが2回呼び出されてしまう)
    # L14.44---Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id) # L14.46にて削除

    # L14.46---Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    #     ---following_ids: following_ids, user_id: id) # L14.47にて削除

    # following_idsをSQLに置き換える(効率的にデータを取得)
    following_ids = "SELECT followed_id FROM relationships
                    WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                    OR user_id = :user_id", user_id: id) # id: self.id
  end

  # L14.10: "following" 関連のメソッド

  # ユーザーをフォローする
  def follow(other_user)
    # self.user.following
    following << other_user
  end

  # ユーザーのフォローを解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしていたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  private
    # メールアドレスをすべて小文字にする
    def downcase_email
      email.downcase!
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
