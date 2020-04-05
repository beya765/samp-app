require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear # mailer init
    @user = users(:michael) # fixture
  end

  # L12.18: パスワード再設定の統合テスト
  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # メールアドレスが無効な場合
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # 〃有効な場合
    post password_resets_path,
      params: { password_reset: { email: @user.email } }
    assert_not_equal @user_reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size # 再設定メールは1通のみ
    assert_not flash.empty?
    assert_redirected_to root_url

    # パスワード再設定フォームのテスト
    user = assigns(:user) # @userのインスタンス変数にアクセス
    # メールアドレスが無効
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # 無効なユーザー
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # メールアドレスが有効、トークンが無効
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # 両方とも有効
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # 無効なパスワードで再設定
    patch password_reset_path(user.reset_token),
          params: { email: user.email, 
                    user: { password: "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    # パスワードが空
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
    # 有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
    assert_nil user.reload['reset_digest']
  end

  # L12.21: パスワード再設定の期限切れのテスト
  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
          params: { password_reset: { email: @user.email } }
    
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago) # 期限切れにする
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "foobar",
                            password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match 'expired', response.body
  end
end
