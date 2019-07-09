class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  
  def create
    # 入力したメールアドレスのユーザを取得
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest # パスワード再設定の属性を設定
      @user.send_password_reset_email # メール送信
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty?
      # 新パスワードが空
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)
      # パスワード更新
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      # 無効な文字列なので失敗
      render 'edit'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # before
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    def valid_user
      # ユーザの正当性を確認
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    def check_expiration
      # トークンの期限切れを確認
      if @user.password_reset_expired?
        flash[:danger] = "Passowrd reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
