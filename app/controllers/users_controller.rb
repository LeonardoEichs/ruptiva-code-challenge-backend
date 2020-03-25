class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = policy_scope(User)

    render json: @users
  end

  def show
    if current_user[:role] == 'admin'
      render json: @user
    else
      if @user == current_user
        render json: @user
      else
        render json: {msg: "You do not have permission for this action"}
      end
    end
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
    if current_user[:role] == 'admin'
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      if @user == current_user
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      else
        render json: {msg: "You do not have permission for this action"}
      end
    end
  end

  def destroy
    if current_user[:role] == 'admin'
      if @user.update({deleted: true})
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      if @user == current_user
        if @user.update({deleted: true})
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      else
        render json: {msg: "You do not have permission for this action"}
      end
    end
    # @user.destroy
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
