require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  # L3.30: setup(各テストが実行される直前で実行されるメソッド)
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "#{@base_title}"
  end
  
  test "should get help" do
    get help_path
    assert_response :success
    # L3.24: <title>タグ内に「Help | Ruby～」文字列があるかチェック
    assert_select "title", "Help | #{@base_title}"
  end
  
  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end

end
