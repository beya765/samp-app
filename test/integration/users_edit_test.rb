require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) # fixtureより呼び出し
  end

  # L10.9: 編集の失敗に対するテスト
  test "unsuccessful edit" do
    log_in_as(@user) # L10.17: Userコントローラーのbeforeアクション対策
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email: "invalid@foo",
                                              password: "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select 'div.alert', "The form contains 4 errors"
  end

  # L10.11: 編集の成功に対するテスト
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    # フレンドリーフォワーディングの演習(https://railstutorial.jp/chapters/updating_and_deleting_users?version=5.1#sec-exercises_friendly_forwarding)
    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as(@user) # L10.17: Userコントローラーのbeforeアクション対策
    assert_nil session[:forwarding_url]
    assert_redirected_to edit_user_url(@user)
    name = "FooBar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user

    # DBから最新のユーザ情報を読み込んで、正しく更新されたか確認
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
