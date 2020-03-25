class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show update destroy]
  before_action :set_user_scoped, only: %i[show update destroy]

  def index
    @users = policy_scope(User)

    render json: @users
  end

  def show
    render json: @user_scoped
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user_scoped.update(user_params)
      render json: @user_scoped
    else
      render json: @user_scoped.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @user_scoped.update({deleted: true})
      render json: @user_scoped
    else
      render json: @user_scoped.errors, status: :unprocessable_entity
    end
  end

    private

  def set_user
    unless (@user = User.find_by(id: params[:id]))
      render json: { error: 'Could not find user' }.to_json,
             status: :bad_request
    end
  end

  def set_user_scoped
    unless (@user_scoped = policy_scope(User).find_by(id: params[:id]))
      render json: { error: 'Could not find user' }.to_json,
             status: :bad_request
    end
  end


  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
  end
  end
