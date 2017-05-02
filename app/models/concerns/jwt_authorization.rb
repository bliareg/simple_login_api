module JwtAuthorization
  extend ActiveSupport::Concern
  SESSION_TIME = 20.minutes.freeze
  attr_accessor :token_expiration_date

  def token
    JwtToken.encode(user_id: self.id, exp: SESSION_TIME.from_now.to_i)
  end

  def token_expired?
    self.token_expiration_date < DateTime.now
  end

  module ClassMethods
    def retrieve_by_token(token)
      data = JwtToken.decode(token).first
      user = User.find(data['user_id'])
      user.token_expiration_date = Time.at(data['exp'])
      user
    rescue
    end
  end

  class JwtToken
    class << self
      def encode(options = {})
        ::JWT.encode(options, Rails.application.secrets.secret_key_base)
      end

      def decode(token)
        ::JWT.decode(token, Rails.application.secrets.secret_key_base)
      end
    end
  end
end
