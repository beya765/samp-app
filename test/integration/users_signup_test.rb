require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
  test "valid signup information" do
    get signup_path
    # 第2引数の1でDB登録の数が増えたことを確認
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: "Example User",
                                          email: "user@example.com",
                                          password: "password",
                                          password_confirmation: "password" } }
    end
    # POSTリクエストの送信結果を見て、指定されたリダイレクト先に移動するメソッド
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in? # L8.27: ユーザー登録後のログインのテスト
  end
end
