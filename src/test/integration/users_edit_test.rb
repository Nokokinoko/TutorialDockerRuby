require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "unsuccessful edit" do
    # ログインして更新ページにアクセスし、更新失敗
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {
      name: "",
      email: "foo@invalid",
      password: "foo",
      password_confirmation: "bar"
    } }
    assert_template 'users/edit'
    # divタグalertクラスのメッセージがあることをテスト
    assert_select "div.alert", "The form contains 4 errors."
  end
  
  test "successful edit" do
    # ログインして更新ページにアクセスし、更新成功
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: {
      name: name,
      email: email,
      password: "",
      password_confirmation: ""
    } }
    # flashメッセージがあることをテスト
    assert_not flash.empty?
    # プロフィールページにリダイレクトすることをテスト
    assert_redirected_to @user
    @user.reload
    # nameとemailの更新が成功していることをテスト
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: {
      name: name,
      email: email,
      password: "",
      password_confirmation: ""
    } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
