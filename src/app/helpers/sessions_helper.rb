module SessionsHelper
  # 指定ユーザでログイン(一時セッション)
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 現在ログイン中のユーザを返す
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  # ログイン済みか判断
  def logged_in?
    !current_user.nil?
  end
  
  # ログアウト
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
