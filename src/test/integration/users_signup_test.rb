require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
  end
  
  test "valid signup information" do
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
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
