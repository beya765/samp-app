require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper # full_title
  
  def setup
    @user = users(:michael) # fixture
  end

  # L13.28: Userプロフィール画面に対するテスト
  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    # h1の内側にgravatarクラスが付与されたimgタグがあるか
    assert_select 'h1>img.gravatar'
    # フォロー/フォロワー数
    assert_match @user.following.count.to_s, response.body
    assert_match @user.followers.count.to_s, response.body
    # HTML全体(response.body)の中にマイクロポストの投稿数が含まれていることをチェック
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
