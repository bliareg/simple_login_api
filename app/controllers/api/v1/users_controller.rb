module Api::V1
  class UsersController < ApplicationController
    skip_before_action :filter_unauthorized, only: :create

    api! 'All users list'
    description 'List of all users, only if logged'
    error 401, 'Unauthorized, missing token or token expired'
    def index
      render json: User.all
    end

    api! 'New user'
    description 'Creates new user only if user is valid'
    error 400, 'Invalid user params'
    param :user, Hash do
      param :first_name, String, allow_blank: true
      param :last_name, String, allow_blank: true
      param :email, String, required: true
      param :password, String, required: true
    end
    example '{"user": { "email": "some_email@mail.com", "password": "password", "first_name": "the name" }}'
    def create
      user = User.new(user_params)
      if user.save
        render json: user
      else
        render json: user.errors.full_messages, status: :bad_request
      end
    end

    api! "Show user"
    description 'List of user with specified id only if logged'
    error 404, 'User not found'
    error 401, 'Unauthorized, missing token or token expired'
    def show
      user = User.find_by_id(params[:id])
      user ? render(json: user) : head(:no_content)
    end

    api! 'Delete user'
    description 'Deletes CURRENT logged user'
    error 401, 'Unauthorized, missing token or token expired'
    def destroy
      if @current_user.destroy
        head :ok
      else
        head :bad_request
      end
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name,
                                   :email, :password)
    end
  end
end
