require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  test "should redirect edit when not logged in" do
    # 未ログインでプロフィールにアクセス
    get edit_user_path(@user)
    # flashメッセージがあることをテスト
    assert_not flash.empty?
    # ログインにリダイレクトすることをテスト
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    # 未ログインで更新ページにアクセス
    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email
    } }
    # flashメッセージがあることをテスト
    assert_not flash.empty?
    # ログインにリダイレクトすることをテスト
    assert_redirected_to login_url
  end
  
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email
    } }
    assert flash.empty?
    assert_redirected_to root_url
  end
end
