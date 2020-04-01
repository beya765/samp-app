require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    # L8.23: usersはfixtureのファイル名users.yml、
    # :michaelというシンボルはユーザーを参照するためのキーを現す。
    @user = users(:michael)
  end

  # L8.9: フラッシュメッセージの残留をキャッチするテスト
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    # ログイン失敗時のフラッシュが別ページに遷移したら表示されないことを確認
    get root_path
    assert flash.empty?
  end

  # L8.23: 有効な情報を使ってユーザーログインをテストする
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    # リダイレクト先が正しいかチェックし、follow_redirect!で実際に移動
    assert_redirected_to @user
    follow_redirect!

    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    # L8.31: ユーザーログアウトのテスト
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
