# frozen_string_literal: true

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :trackable, :rememberable, :timeoutable
  include DeviseTokenAuth::Concerns::User
  enum role: { user: 0, admin: 1 }

  def as_json
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      role: role
    }
  end
end
