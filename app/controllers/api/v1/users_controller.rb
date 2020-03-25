# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::ApiController
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User.all

    render json: @users
  end

  def show
    render json: @user
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
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # @user.destroy
    if @user.update({deleted: true})
        render json: { msg: 'User deleted with success' }.to_json
    else
        render json: @user.errors, status: :unprocessable_entity
    end  
  end

    private

  def set_user
    unless (@user = User.find_by(id: params[:id]))
      render json: { error: 'Could not find user' }.to_json,
             status: :bad_request
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
  end
  end
