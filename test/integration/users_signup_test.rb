require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    # L11.33: 並行して行われる他のテストでメールが配信されたときにエラーが発生するため、初期化
    ActionMailer::Base.deliveries.clear
  end

  # L7.23: 無効なユーザー登録に対するテスト
  test "invalid signup information" do
    get signup_path
    # signup_pathに対してPOST
    # User.countでDBの登録件数が変わってないことを確認
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    # L7.25: エラーメッセージのテスト
    assert_select 'div#error_explanation'
    assert_select 'div.alert'

    assert_select 'form[action="/signup"]'
  end

  # L7.33: 有効なユーザー登録に対するテスト
  test "valid signup information with account activation" do
    get signup_path
    # 第2引数の1でDB登録の数が増えたことを確認
    assert_difference 'User.count', 1 do
      # L11.33: signup_path を users_path へ
      post users_path, params: { user: { name: "Example User",
                                          email: "user@example.com",
                                          password: "password",
                                          password_confirmation: "password" } }
    end
    # L11.33: 配信されたメッセージがきっかり1つであるか確認
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user) # assignsで対応するアクション内のインスタンス変数にアクセス
    assert_not user.activated?
    # L11.33: 有効化していない状態でログインしてみる
    log_in_as(user)
    assert_not is_logged_in?
    # L11.33: 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # L11.33: トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # L11.33: 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    # POSTリクエストの送信結果を見て、指定されたリダイレクト先に移動するメソッド
    follow_redirect!
    # L11.24: 失敗するテストを一時的にコメントアウトする(L11.33で戻した)
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in? # L8.27: ユーザー登録後のログインのテスト
  end
end
