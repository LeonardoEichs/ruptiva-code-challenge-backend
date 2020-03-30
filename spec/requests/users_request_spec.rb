require 'rails_helper'

RSpec.describe 'User requests' do

    describe 'GET /users without authentication' do
        before do
            get '/users'
        end
        it 'returns an unauthorized code' do
            expect(response).to have_http_status(401)
        end
    end

    describe 'GET /users with user role' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            auth_header = user.create_new_auth_token
            get '/users', params: {}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "body response contains only one user" do
            json = JSON.parse(response.body)
            expect(json.length()).to  eq(1)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json[0].keys).to include(
                "id", 
                "first_name", 
                "last_name",
                "email",
                "role"
                )
        end
    end

    describe 'GET /users with admin role' do
        before do
            user = User.create(first_name: 'Admin', last_name: 'Admin', email: 'admin@test.com', password: "password", password_confirmation: "password", role: 'admin')
            User.create(first_name: 'Teste1', last_name: 'Teste1', email: 'test1@test.com', password: "password", password_confirmation: "password")
            User.create(first_name: 'Teste2', last_name: 'Teste2', email: 'test2@test.com', password: "password", password_confirmation: "password")
            User.create(first_name: 'Teste3', last_name: 'Teste3', email: 'test3@test.com', password: "password", password_confirmation: "password")
            User.create(first_name: 'Teste4', last_name: 'Teste4', email: 'test4@test.com', password: "password", password_confirmation: "password")
            auth_header = user.create_new_auth_token
            get '/users', params: {}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "body response contains only all users" do
            json = JSON.parse(response.body)
            expect(json.length()).to  eq(5)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json[0].keys).to include(
                "id", 
                "first_name", 
                "last_name",
                "email",
                "role"
                )
        end
    end

    describe 'GET /users/:id without authentication' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            get "/users/#{user.id}"
        end
        it 'returns an unauthorized code' do
            expect(response).to have_http_status(401)
        end
    end

    describe 'GET /users/:id with user role' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            auth_header = user.create_new_auth_token
            get "/users/#{user.id}", params: {}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json.keys).to include(
                "id", 
                "first_name", 
                "last_name",
                "email",
                "role"
                )
        end
        it "JSON body response first_name should be Teste" do
            json = JSON.parse(response.body)
            expect(json["first_name"]).to eq("Teste")
        end
    end

    describe 'GET /users/:id to non-authorized id' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            jon_doe = User.create(first_name: 'Jon', last_name: 'Doe', email: 'jon@test.com', password: "password", password_confirmation: "password")
            auth_header = user.create_new_auth_token
            get "/users/#{jon_doe.id}", params: {}, headers: auth_header
        end
        it 'returns a bad request code' do
            expect(response).to have_http_status(:bad_request)
        end
        it "JSON body response contains msg error" do
            json = JSON.parse(response.body)
            expect(json).to include(
                "error" => "Could not find user"
            )
        end
    end

    describe 'GET /users/:id with admin role' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password", role: 'admin')
            auth_header = user.create_new_auth_token
            get "/users/#{user.id}", params: {}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json.keys).to include(
                "id", 
                "first_name", 
                "last_name",
                "email",
                "role"
                )
        end
        it "JSON body response first_name should be Teste" do
            json = JSON.parse(response.body)
            expect(json["first_name"]).to eq("Teste")
        end
    end

    describe "GET /users/:id to an id other than admin's own" do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password", role: 'admin')
            jon_doe = User.create(first_name: 'Jon', last_name: 'Doe', email: 'jon@test.com', password: "password", password_confirmation: "password")
            auth_header = user.create_new_auth_token
            get "/users/#{jon_doe.id}", params: {}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json.keys).to include(
                "id", 
                "first_name", 
                "last_name",
                "email",
                "role"
                )
        end
        it "JSON body response first_name should be Jon" do
            json = JSON.parse(response.body)
            expect(json["first_name"]).to eq("Jon")
        end
    end

    describe 'GET /users/:id without authentication' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            get "/users/#{user.id}"
        end
        it 'returns an unauthorized code' do
            expect(response).to have_http_status(401)
        end
    end

    describe 'GET /users/:id with user role' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            auth_header = user.create_new_auth_token
            get "/users/#{user.id}", params: {}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json.keys).to include(
                "id", 
                "first_name", 
                "last_name",
                "email",
                "role"
                )
        end
    end

    describe 'GET /users/:id to non-authorized id' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            auth_header = user.create_new_auth_token
            get "/users/#{user.id + 1}", params: {}, headers: auth_header
        end
        it 'returns a bad request code' do
            expect(response).to have_http_status(:bad_request)
        end
        it "JSON body response contains msg error" do
            json = JSON.parse(response.body)
            expect(json).to include(
                "error" => "Could not find user"
            )
        end
    end

    describe 'GET /users/:id with admin role' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password", role: 'admin')
            auth_header = user.create_new_auth_token
            get "/users/#{user.id}", params: {}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json.keys).to include(
                "id", 
                "first_name", 
                "last_name",
                "email",
                "role"
                )
        end
    end

    describe "GET /users/:id to an id other than admin's own" do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password", role: 'admin')
            jon_doe = User.create(first_name: 'Jon', last_name: 'Doe', email: 'jon@test.com', password: "password", password_confirmation: "password")
            auth_header = user.create_new_auth_token
            get "/users/#{jon_doe.id}", params: {}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json.keys).to include(
                "id", 
                "first_name", 
                "last_name",
                "email",
                "role"
                )
        end
        it "JSON body response first_name should be Jon" do
            json = JSON.parse(response.body)
            expect(json["first_name"]).to eq("Jon")
        end
    end

    describe 'PUT /users/:id without authentication' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            put "/users/#{user.id}"
        end
        it 'returns an unauthorized code' do
            expect(response).to have_http_status(401)
        end
    end

    describe 'PUT /users/:id with user role' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            auth_header = user.create_new_auth_token
            put "/users/#{user.id}", params: {user: {first_name: "Jon", last_name: "Doe"}}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json.keys).to include(
                "id", 
                "first_name", 
                "last_name",
                "email",
                "role"
                )
        end
        it "JSON body response first_name should be Jon and last_name should be Doe" do
            json = JSON.parse(response.body)
            expect(json["first_name"]).to eq("Jon")
            expect(json["last_name"]).to eq("Doe")
        end
    end

    describe 'PUT /users/:id with user role try to change attribute that he has no access' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            @created_user_id = user.id
            auth_header = user.create_new_auth_token
            put "/users/#{user.id}", params: {user: {deleted: true}}, headers: auth_header
        end
        describe 'GET /users/:id to user to check if it still is the same' do
            it "JSON body response deleted should still be false" do
                admin = User.create(first_name: 'Admin', last_name: 'Teste', email: 'admin@test.com', password: "password", password_confirmation: "password", role: 'admin')
                auth_header = admin.create_new_auth_token
                get "/users/#{@created_user_id}", params: {}, headers: auth_header
                json = JSON.parse(response.body)
                expect(json["deleted"]).to eq(false)
            end
        end
    end

    describe 'PUT /users/:id with user role try to change attribute that he has no access' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            @created_user_id = user.id
            auth_header = user.create_new_auth_token
            put "/users/#{user.id}", params: {user: {role: "admin"}}, headers: auth_header
        end
        describe 'GET /users/:id to user to check if it still is the same' do
            it "JSON body response role should still be user" do
                admin = User.create(first_name: 'Admin', last_name: 'Teste', email: 'admin@test.com', password: "password", password_confirmation: "password", role: 'admin')
                auth_header = admin.create_new_auth_token
                get "/users/#{@created_user_id}", params: {}, headers: auth_header
                json = JSON.parse(response.body)
                expect(json["role"]).to eq("user")
            end
        end
    end

    describe 'PUT /users/:id user role to non-authorized id' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            @jon_doe = User.create(first_name: 'Jon', last_name: 'Doe', email: 'jon@test.com', password: "password", password_confirmation: "password")
            auth_header = user.create_new_auth_token
            put "/users/#{@jon_doe.id}", params: {user: {first_name: "Jane"}}, headers: auth_header
        end
        it 'returns a bad request code' do
            expect(response).to have_http_status(:bad_request)
        end
        it "JSON body response contains msg error" do
            json = JSON.parse(response.body)
            expect(json).to include(
                "error" => "Could not find user"
            )
        end
        describe 'GET /users/:id to Jon Doe to check if it still is the same' do
            it "JSON body response first_name should still be Jon" do
                auth_header = @jon_doe.create_new_auth_token
                get "/users/#{@jon_doe.id}", params: {}, headers: auth_header
                json = JSON.parse(response.body)
                expect(json["first_name"]).to eq("Jon")
            end
        end
    end

    describe 'PUT /users/:id with admin role' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password", role: 'admin')
            auth_header = user.create_new_auth_token
            put "/users/#{user.id}", params: {user: {first_name: "Jon", last_name: "Doe"}}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json.keys).to include(
                "id", 
                "first_name", 
                "last_name",
                "email",
                "role"
                )
        end
        it "JSON body response first_name should be Jon and last_name should be Doe" do
            json = JSON.parse(response.body)
            expect(json["first_name"]).to eq("Jon")
            expect(json["last_name"]).to eq("Doe")
        end
    end

    describe "PUT /users/:id to an id other than admin's own" do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password", role: 'admin')
            jon_doe = User.create(first_name: 'Jon', last_name: 'Doe', email: 'jon@test.com', password: "password", password_confirmation: "password")
            auth_header = user.create_new_auth_token
            put "/users/#{jon_doe.id}", params: {user: {first_name: "Jane"}}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json.keys).to include(
                "id", 
                "first_name", 
                "last_name",
                "email",
                "role"
                )
        end
        it "JSON body response first_name should be Jane" do
            json = JSON.parse(response.body)
            expect(json["first_name"]).to eq("Jane")
        end
    end

    describe 'DEL /users/:id without authentication' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            delete "/users/#{user.id}"
        end
        it 'returns an unauthorized code' do
            expect(response).to have_http_status(401)
        end
    end

    describe 'DEL /users/:id with user role' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            @created_user_id = user.id
            auth_header = user.create_new_auth_token
            delete "/users/#{user.id}", params: {}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json["msg"]).to eq("User deleted!")
        end
        it "user has deleted attribute as true" do
            admin = User.create(first_name: 'Admin', last_name: 'Teste', email: 'admin@test.com', password: "password", password_confirmation: "password", role: 'admin')
            auth_header = admin.create_new_auth_token
            get "/users/#{@created_user_id}", params: {}, headers: auth_header
            json = JSON.parse(response.body)
            expect(json["deleted"]).to eq(true)
        end
    end

    describe "DEL /users/:id with user role and try to use it's authentication" do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            @auth_header = user.create_new_auth_token
            delete "/users/#{user.id}", params: {}, headers: @auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json["msg"]).to eq("User deleted!")
        end
        it "try to use deleted user's authentication" do
            get "/users", params: {}, headers: @auth_header
            expect(response).to have_http_status(401)
        end
    end


    describe 'DEL /users/:id user role to non-authorized id' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password")
            @jon_doe = User.create(first_name: 'Jon', last_name: 'Doe', email: 'jon@test.com', password: "password", password_confirmation: "password")
            auth_header = user.create_new_auth_token
            delete "/users/#{@jon_doe.id}", params: {}, headers: auth_header
        end
        it 'returns a bad request code' do
            expect(response).to have_http_status(:bad_request)
        end
        it "JSON body response contains msg error" do
            json = JSON.parse(response.body)
            expect(json).to include(
                "error" => "Could not find user"
            )
        end
        describe 'GET /users/:id to Jon Doe to check if it still is not deleted' do
            it "JSON body response deleted should be false" do
                admin = User.create(first_name: 'Admin', last_name: 'Teste', email: 'admin@test.com', password: "password", password_confirmation: "password", role: 'admin')
                auth_header = admin.create_new_auth_token    
                get "/users/#{@jon_doe.id}", params: {}, headers: auth_header
                json = JSON.parse(response.body)
                expect(json["deleted"]).to eq(false)
            end
        end
    end

    describe 'DEL /users/:id with admin role' do
        before do
            @user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password", role: 'admin')
            auth_header = @user.create_new_auth_token
            delete "/users/#{@user.id}", params: {}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json["msg"]).to eq("User deleted!")
        end
        describe 'GET /users/:id to user to check if it is deleted' do
            it "JSON body response deleted should be true" do
                admin = User.create(first_name: 'Admin', last_name: 'Teste', email: 'admin@test.com', password: "password", password_confirmation: "password", role: 'admin')
                auth_header = admin.create_new_auth_token    
                get "/users/#{@user.id}", params: {}, headers: auth_header
                json = JSON.parse(response.body)
                expect(json["deleted"]).to eq(true)
            end
        end

    end

    describe "DEL /users/:id to an id other than admin's own" do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password", role: 'admin')
            @jon_doe = User.create(first_name: 'Jon', last_name: 'Doe', email: 'jon@test.com', password: "password", password_confirmation: "password")
            auth_header = user.create_new_auth_token
            delete "/users/#{@jon_doe.id}", params: {}, headers: auth_header
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json.keys).to include(
                "id", 
                "first_name", 
                "last_name",
                "email",
                "role"
                )
        end
        it "Jon Doe user has deleted attribute as true" do
            json = JSON.parse(response.body)
            expect(json["deleted"]).to eq(true)
        end
        describe 'GET /users/:id to Jon Doe to check if it still is not deleted' do
            it "JSON body response deleted should be true" do
                admin = User.create(first_name: 'Admin', last_name: 'Teste', email: 'admin@test.com', password: "password", password_confirmation: "password", role: 'admin')
                auth_header = admin.create_new_auth_token    
                get "/users/#{@jon_doe.id}", params: {}, headers: auth_header
                json = JSON.parse(response.body)
                expect(json["deleted"]).to eq(true)
            end
        end
    end

    describe 'POST /users to create a new user' do
        before do
            post "/users", params: {first_name: "Jon", last_name: "Doe", email: "jon@email.com", password: "12345", password_confirmation: "12345"}, headers: {}
            json = JSON.parse(response.body)
            @created_user_id = json["data"]["id"]
        end
        it 'returns a success code' do
            expect(response).to have_http_status(:success)
        end
        it "JSON body response contains expected users attributes" do
            json = JSON.parse(response.body)
            expect(json["data"].keys).to include(
                "id", 
                "first_name", 
                "last_name",
                "email",
                "role"
                )
        end
        it "JSON body response first_name should be Jon and last_name should be Doe" do
            json = JSON.parse(response.body)
            expect(json["data"]["first_name"]).to eq("Jon")
            expect(json["data"]["last_name"]).to eq("Doe")
        end
        describe 'GET /users/:id to Jon Doe to check if it has the correct values' do
            it "JSON body response first_name should be Jon and last_name Doe" do
                user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", password_confirmation: "password", role: 'admin')
                auth_header = user.create_new_auth_token
                get "/users/#{@created_user_id}", params: {}, headers: auth_header
                json = JSON.parse(response.body)
                expect(json["first_name"]).to eq("Jon")
                expect(json["last_name"]).to eq("Doe")
            end
        end
    end

    describe 'POST /users try to create an new user with an already signed up email' do
        before do
            post "/users", params: {first_name: "Teste", last_name: "Teste", email: "teste@email.com", password: "12345", password_confirmation: "12345"}, headers: {}
            post "/users", params: {first_name: "Teste2", last_name: "Teste2", email: "teste@email.com", password: "12345", password_confirmation: "12345"}, headers: {}
        end
        it 'returns an unprocessable entity code' do
            expect(response).to have_http_status(:unprocessable_entity)
        end
        it "JSON body response error message should tell that email has already been taken" do
            json = JSON.parse(response.body)
            expect(json["errors"]["full_messages"][0]).to eq("Email has already been taken")
        end
    end


    describe 'POST /users try to create an new user without password confirmation' do
        before do
            post "/users", params: {first_name: "Teste", last_name: "Teste", email: "teste@email.com", password: "12345"}, headers: {}
        end
        it 'returns an unprocessable entity code' do
            expect(response).to have_http_status(:unprocessable_entity)
        end
        it "JSON body response error message should tell that it needs password confirmation" do
            json = JSON.parse(response.body)
            expect(json["errors"]["full_messages"][0]).to eq("Password confirmation can't be blank")
        end
    end

    describe 'POST /users try to create an new user with wrong password confirmation' do
        before do
            post "/users", params: {first_name: "Teste", last_name: "Teste", email: "teste@email.com", password: "12345", password_confirmation: "123456789"}, headers: {}
        end
        it 'returns an unprocessable entity code' do
            expect(response).to have_http_status(:unprocessable_entity)
        end
        it "JSON body response error message should tell that password confirmation does not match password" do
            json = JSON.parse(response.body)
            expect(json["errors"]["full_messages"][0]).to eq("Password confirmation doesn't match Password")
        end
    end


end
