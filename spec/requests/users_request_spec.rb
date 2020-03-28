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
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password")
            auth_header = user.create_new_auth_token
            get '/users', params: {}, headers: auth_header
        end
        it 'returns an success code' do
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
            user = User.create(first_name: 'Admin', last_name: 'Admin', email: 'admin@test.com', password: "password", role: 'admin')
            User.create(first_name: 'Teste1', last_name: 'Teste1', email: 'test1@test.com', password: "password")
            User.create(first_name: 'Teste2', last_name: 'Teste2', email: 'test2@test.com', password: "password")
            User.create(first_name: 'Teste3', last_name: 'Teste3', email: 'test3@test.com', password: "password")
            User.create(first_name: 'Teste4', last_name: 'Teste4', email: 'test4@test.com', password: "password")
            auth_header = user.create_new_auth_token
            get '/users', params: {}, headers: auth_header
        end
        it 'returns an success code' do
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
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password")
            get "/users/#{user.id}"
        end
        it 'returns an unauthorized code' do
            expect(response).to have_http_status(401)
        end
    end

    describe 'GET /users/:id with user role' do
        before do
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password")
            auth_header = user.create_new_auth_token
            get "/users/#{user.id}", params: {}, headers: auth_header
        end
        it 'returns an success code' do
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
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password")
            auth_header = user.create_new_auth_token
            get "/users/#{user.id + 1}", params: {}, headers: auth_header
        end
        it 'returns an success code' do
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
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", role: 'admin')
            auth_header = user.create_new_auth_token
            get "/users/#{user.id}", params: {}, headers: auth_header
        end
        it 'returns an success code' do
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
            user = User.create(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: "password", role: 'admin')
            jon_doe = User.create(first_name: 'Jon', last_name: 'Doe', email: 'jon@test.com', password: "password")
            auth_header = user.create_new_auth_token
            get "/users/#{jon_doe.id}", params: {}, headers: auth_header
        end
        it 'returns an success code' do
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


#    context "GET #show" do
#    it "renders the :show view" do 
#     get :show, params: {id: @user.id}
#     expect(response).to have_http_status(:success)
#    end
#   end

#   context "GET #show" do
#   it "renders the :show view" do 
#    get :show, params: {id: (@user.id + 1)}
#    expect(response).not_to have_http_status(:success)
#   end
#  end

    
end
