class User < ApplicationRecord
  include JwtAuthorization
  has_secure_password

  #VALID_EMAIL = /\A((\w[\w+\-.\/]*[\w]@[a-z\d]+\.[a-z]+\z)|\s*\z)/i
  #VALID_PASSWORD = /\A(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}\z/i
  #VALID_NAME = /\A(((\d*([^\^"'`ʼ#\$%*:<\[({})\]>?\/\\|~%&*:;\s+=@\d])\d*)+\z)|\s*\z)/

  validates :password, :email, presence: true
  validates :email, uniqueness: true
  validates :first_name, :last_name, length: {minimum: 5, maximum: 30}, allow_blank: true

  def self.authorize(options)
    user = User.find_by(email: options[:email])
    if user && user.authenticate(options[:password])
      user
    end
  end
end
