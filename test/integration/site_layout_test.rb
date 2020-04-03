# https://railstutorial.jp/chapters/filling_in_the_layout?version=5.1#sec-layout_link_tests
require 'test_helper'


class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) # fixtureより呼び出し
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home' # 指定テンプレートが選択されたかチェック
    # 該当リンクが存在するかどうか
    assert_select "a[href=?]", root_path, count: 2  # ロゴ、navバーの2つ
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("Sign up")
  end

  test "layout links when logged in" do
    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)    
    assert_select "a[href=?]", logout_path
  end
end
