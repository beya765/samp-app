class UsersController < ApplicationController
  def new
    @user = User.new # L7.14
  end
  
  # L7.5
  def show
    @user = User.find(params[:id])
    # debugger # 使用方法(https://railstutorial.jp/chapters/sign_up?version=5.1#sec-debugger)
  end

  # L7.18
  def create
    # ユーザ登録で送られてきたPOSTデータの内容を限定
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "userコントローラー: Welcome to the Sample App!!"
      # L7.28: redirect_to user_url(@user)と等価
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    # L7.19: Strong Parametersで許可されたパラメータを指定(不正パラメータ対策)
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation)
    end
end
