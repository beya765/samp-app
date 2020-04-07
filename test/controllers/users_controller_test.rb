require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) # fixtureより呼び出し
    @other_user = users(:archer)
  end

  # L10.34: indexアクションのリダイレクトをテスト
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  # L10.20: editアクションの保護(beforeフィルター)に対するテスト
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  # L10.20: updateアクションの保護(beforeフィルター)に対するテスト
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # L10.56: admin属性の変更が禁止されていることをテスト
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { password: "",
                                                    password_confirmation: "",
                                                    admin: true } }
    assert_not @other_user.reload.admin?
  end

  # L10.24: 間違ったユーザーが編集(edit, update)しようとしたときのテスト
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user) 
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  # L10.61: 管理者権限の制御をアクションレベルでテスト(未ログイン, 管理者権限なし)
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  # L14.24: フォロー/フォロワーページの認可をテストする

  test "should redirect following when not logged in" do
    get following_user_path(@user) # /users/1/following
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
