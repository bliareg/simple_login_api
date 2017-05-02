class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action { response.headers['Access-Control-Expose-Headers'] = 'Authorization' }
  before_action :authorize_with_token
  before_action :filter_unauthorized

  def authorize_with_token
    # binding.pry
    @current_user = retrieve_current_user
    if @current_user.present? && !@current_user.token_expired?
      response.headers['Authorization'] = "Token token='#{@current_user.token}'"
    end
  end

  def filter_unauthorized
    render json: { message: 'Unauthorized' }, status: :unauthorized and return if @current_user.nil?
  end

  def retrieve_current_user
    authenticate_with_http_token do |token, opts|
      User.retrieve_by_token(token)
    end
  end
end
