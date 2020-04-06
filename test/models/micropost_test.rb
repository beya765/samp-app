require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael) # fixture
    # ---L13.4: このコードは慣習的に正しくない
    # ---@micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    # buildメソッドはオブジェクトを返すがDBには反映されない
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  # L13.4: 新しいMicropostの有効性に対するテスト

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?    
  end

  # L13.7: Micropostモデルのバリデーションに対するテスト

  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # L13.14: マイクロポストの順序付けをテストする
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
