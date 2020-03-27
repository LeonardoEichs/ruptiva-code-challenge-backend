# frozen_string_literal: true

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :trackable, :rememberable, :timeoutable
  include DeviseTokenAuth::Concerns::User
  enum role: { user: 0, admin: 1 }


end
