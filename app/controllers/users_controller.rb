class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show update destroy]
  before_action :set_user_scoped, only: %i[show update destroy]

  def index
    @users = policy_scope(User)

    render json: json_render_scope(@users)
  end

  def show
    render json: json_render_scope(@user_scoped)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: json_render_scope(@user), status: :created
    else
      render json: json_render_scope(@user).errors, status: :unprocessable_entity
    end
  end

  def update
    if @user_scoped.update(user_params)
      render json: json_render_scope(@user_scoped)
    else
      render json: json_render_scope(@user_scoped).errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @user_scoped.update({deleted: true})
      if @user_scoped.id == current_user.id
        current_user.tokens = nil
        current_user.save
        sign_out current_user
        render json: {msg: "User deleted!"}
      else
        @user_scoped.tokens = nil
        @user_scoped.save
        render json: json_render_scope(@user_scoped)
      end
    else
      render json: json_render_scope(@user_scoped).errors, status: :unprocessable_entity
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

  def json_render_scope(complete_user)
    if current_user.admin?
      complete_user.as_json
    else 
      complete_user.as_json(only: [:id, :first_name, :last_name, :email, :role])
    end
  end

  def user_params
    if(current_user.admin?)
      params.require(:user).permit(:id, :provider, :uid, :first_name, :last_name, :email, :role, :created_at, :updated_at)
    else
      params.require(:user).permit(:first_name, :last_name, :email)
    end
  end

  end
