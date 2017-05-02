module Api::V1
  class SessionsController < ApplicationController
    skip_before_action :filter_unauthorized

    api! 'Login action'
    description 'Returns TOKEN if email && password auth ok'
    param :email, String
    param :password, String
    error 400, 'Invalid or missing email or password'
    example '{ "email": "some_email@mail.com", "password": "password" }'
    def create
      if (user = User.authorize(session_params))
        render json: { token: user.token }
      else
        head :bad_request
      end
    end

    def session_params
      params.permit(:email, :password)
    end
  end
end
