# https://railstutorial.jp/chapters/filling_in_the_layout?version=5.1#sec-layout_link_tests
require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
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
end
