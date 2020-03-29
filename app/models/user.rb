# frozen_string_literal: true

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :trackable, :rememberable, :timeoutable
  include DeviseTokenAuth::Concerns::User
  enum role: { user: 0, admin: 1 }
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true
  validates :password, :presence => true
end
