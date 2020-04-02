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
    delete logout_path # 例: Firefox
    assert_not is_logged_in?
    assert_redirected_to root_url
    # L9.14: 2番目のウィンドウでログアウトをクリックした場合のシミュレート
    delete logout_path # 例: Chrome
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  # L9.25: [remember me] チェックボックスのテスト
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    # テスト内ではcookiesメソッドにシンボルを使えないため、文字列キー
    assert_not_empty cookies['remember_token']
    # L9.28: assigns/インスタンス変数(この場合、sessionコントローラーcreate内@user)に
    # 対応するシンボルを渡し、仮想のremember_token属性にアクセスできるようにする特殊メソッド
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    # クッキーを保持してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
