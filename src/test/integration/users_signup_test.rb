require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    # ユーザ登録(失敗)後にユーザ数が変わらないことをテスト
    assert_no_difference 'User.count' do
      post users_path, params: { user: {
        name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar"
      } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  
  test "valid signup information with account activation" do
    get signup_path
    # ユーザ登録(成功)後にユーザ数が+1していることをテスト
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {
        name: "Example User",
        email: "user@example.com",
        password: "password",
        password_confirmation: "password"
      } }
    end
    # 配信メッセージが1件であることをテスト
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Userコントローラの@userにアクセス
    user = assigns(:user)
    # 有効化が完了していないことをテスト
    assert_not user.activated?
    log_in_as(user)
    # ログイン出来ないことをテスト
    assert_not is_logged_in?
    # 有効化トークンが不正
    get edit_account_activation_path("Invalid token", email: user.email)
    assert_not is_logged_in?
    # メールアドレスが不正
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 有効化
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
