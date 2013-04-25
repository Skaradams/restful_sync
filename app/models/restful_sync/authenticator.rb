module RestfulSync
  class Authenticator < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise :token_authenticatable
  
    attr_accessible :authentication_token
    # Setup accessible (or protected) attributes for your model
    # attr_accessible :email, :password, :password_confirmation, :remember_me
    # attr_accessible :title, :body
  end
end
