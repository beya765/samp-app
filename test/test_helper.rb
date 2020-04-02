ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
# L3.44: red や green を表示できるようにする
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # L5.35 test環境でもfull_titleヘルパーを使用可能に
  include ApplicationHelper

  # L8.26: テスト中のログインステータスを論理値で返すメソッド
  # appのヘルパーメソッド(current_user)は呼び出せないので代用
  def is_logged_in?
    # テストユーザーがログイン中の場合にtrueを返す
    !session[:user_id].nil?
  end

  # L9.24: テストユーザーとしてログインする
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  # L9.24: テストユーザーとしてログインする(統合テスト用)
  # sessionを直接取り扱うことができないので、Sessionsリソースに対してpostを送信することで代用
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
