class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      @user.addresses.create(address_params)
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.name}! You are now registered and logged in."
      redirect_to "/users/#{@user.id}"
    else
      flash[:error] = @user.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  def show
    if current_user && current_admin?
      @user = current_user
    elsif current_user
      @user = current_user
    end
  end

  def edit
    @user = current_user
  end

  def password_edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    if user_params.include?(:password)
      redirect_to "/users/#{@user.id}"
      flash[:success] = 'Your password has been updated'
    elsif @user.save
      redirect_to "/users/#{@user.id}"
      flash[:success] = 'Your profile has been updated'
    else
      redirect_to "/users/#{@user.id}/edit"
      flash[:error] = @user.errors.full_messages.uniq
    end
  end

  private

  def require_user
    render file: '/public/404' unless current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def address_params
    params.permit(:address, :city, :state, :zip, :address_nickname)
  end
end
