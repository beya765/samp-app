require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:michael) # fixtureから呼び出し
    remember @user #　ユーザ記憶
  end

  # L9.31: 永続的セッションのテスト
  test "current user returns right user when session is nil" do
    # 記憶ユーザとcurrent_userメソッドで返ってきたユーザを比較
    assert_equal @user, current_user
    assert is_logged_in?
  end

  # ユーザーの記憶ダイジェストが記憶トークンと正しく対応していない場合
  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end