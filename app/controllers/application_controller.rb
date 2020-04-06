class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # L8.13: どのコントローラでもSessionヘルパーのメソッドが使えるようになる
  include SessionsHelper

  private
  # L13.32: logged_in_userメソッドをUsersコントローラから移動
  # Users と Micropostsの両コントローラーのbeforeフィルターで必要となるため
  
    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
