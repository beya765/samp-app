require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    # L6.5: setup内で宣言したインスタンス変数は全てのテスト内で使用可
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    # L6.5: 有効なUserかどうかをテスト
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    # L6.7: Userオブジェクトが有効でなくなったことを確認
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  # L6.14: 長さの検証
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # L6.18: 有効なメールフォーマットのテスト
  test "email validation should accept valid addresses" do
    # %w[]で簡単にメアドの配列を作成できる
    valid_addresses = %w[user@example.com USER@foo.COM alice@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  # L6.19: 無効なメールフォーマットのテスト
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # L6.24: 重複するメールアドレス拒否のテスト(model-User:email-uniqueness部分)
  test "email addresses should be unique" do
    # @user.dupでデータの複製
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase 
    @user.save
    assert_not duplicate_user.valid?
  end

  # L6.33: メールアドレス小文字化に対するテスト
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    # reloadメソッド = データベースの値に合わせて更新する
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # L6.41: パスワードの最小文字数をテストする
  test "password should be present (nonblank)" do
    # 多重代入。passwordとpasswordconfirmationに対して同時に代入
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # L9.17: ダイジェストが存在しない場合のauthenticated?のテスト
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
end
