require 'spec_helper'

module AuthHelper
 def login_user
    @user = User.create(first_name: 'Leonardo', last_name: 'Eichstaedt', email: 'test@test.com', password: "password", password_confirmation: "password")
    @auth_header = @user.create_new_auth_token
 end

 def login_admin
    @admin = User.create(first_name: 'Leonardo', last_name: 'Eichstaedt', email: 'test@test.com', password: "password", password_confirmation: "password", role: "admin")
    request.headers.merge!(@admin.create_new_auth_token) if sign_in(@admin)
 end
end