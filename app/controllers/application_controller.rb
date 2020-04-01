class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # L8.13: どのコントローラでもSessionヘルパーのメソッドが使えるようになる
  include SessionsHelper
end
