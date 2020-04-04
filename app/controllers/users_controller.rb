class UsersController < ApplicationController
  # L10.15: beforeフィルターにlogged_in_user追加
  # L10.35: indexアクションにはログインを要求する
  # L10.58: 実際に動作するdestroyアクションを追加する
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # L10.25: beforeフィルターを使って編集/更新ページを保護
  before_action :correct_user, only: [:edit, :update]
  # L10.59: beforeフィルターでdestroyアクションを管理者だけに限定する
  before_action :admin_user, only: :destroy

  # L10.35
  def index
    @users = User.where(activated: true).paginate(page: params[:page])

    # ---L11.40より置き換え
    # ---# L10.46: Usersをページネート
    # ---@users = User.paginate(page: params[:page])

    # ---L10.46より置き換え: @users = User.all
  end

  def new
    @user = User.new # L7.14
  end
  
  # L7.5
  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated? # L11.40
    # debugger # 使用方法(https://railstutorial.jp/chapters/sign_up?version=5.1#sec-debugger)
  end

  # L7.18
  def create
    # ユーザ登録で送られてきたPOSTデータの内容をprivate内のuser_paramsで選定
    @user = User.new(user_params)
    if @user.save
      # L11.23: ユーザー登録にアカウント有効化を追加
      @user.send_activation_email # L11.36: ユーザーモデルオブジェクトからメールを送信する
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url

      # ---アカウント有効化処理に伴い修正
      # ---log_in @user # L8.25: ユーザー登録中にログインする
      # ---flash[:success] = "userコントローラー: Welcome to the Sample App!!"
      # ---# L7.28: redirect_to user_url(@user)と等価
      # ---redirect_to @user
    else
      render 'new'
    end
  end

  # L10.1
  def edit
    # ---@user = User.find(params[:id])
    # ---L10.25のbefore~correct_userで@userを定義しているためコメントアウト
  end
  
  # L10.8
  def update
    # ---@user = User.find(params[:id])
    # ---L10.25のbefore~correct_userで@userを定義しているためコメントアウト
    # ユーザ登録で送られてきたPATCHデータの内容をprivate内で選定
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # L10.58: 実際に動作するdestroyアクションを追加する
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    # L7.19: Strong Parametersで許可されたパラメータを指定(不正パラメータ対策)
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation)
    end

    # beforeアクション

    # L10.15: ログイン済みユーザーかどうか確認
    def logged_in_user
      # unless: if文の逆。つまりfalse(未ログイン)の場合の処理
      unless logged_in?
        store_location # L10.31: アクセス先URL保存
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # L10.25: 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      # ユーザーが異なる場合、ホーム画面へ(current_user?はセッションヘルパーメソッド)
      redirect_to(root_url) unless current_user?(@user)
    end

    # L10.59: 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
