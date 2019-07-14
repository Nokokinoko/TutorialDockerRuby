require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
  end
  
  test "should redirect create when not logged in" do
    # 未ログインであれば投稿しても投稿数に変化がないことをテスト
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    # 未ログインであれば削除しても投稿数に変化がないことをテスト
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    # 自身の投稿でないため削除不可、投稿数に変化がないことをテスト
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
end
