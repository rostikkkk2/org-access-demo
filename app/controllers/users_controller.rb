class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.first_name}! You are #{@user.age} years old."
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, 
                                 :first_name, :last_name, :date_of_birth)
  end
end