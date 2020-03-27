require 'rails_helper'
include AuthHelper

RSpec.describe UsersController, type: :controller do
    before(:each) do
        login_user
    end

    context "GET #index" do
    it "renders the :index view" do 
     get :index
     expect(response).to have_http_status(:success)
    end
   end

   context "GET #show" do
   it "renders the :show view" do 
    get :show, params: {id: @user.id}
    expect(response).to have_http_status(:success)
   end
  end

  context "GET #show" do
  it "renders the :show view" do 
   get :show, params: {id: (@user.id + 1)}
   expect(response).not_to have_http_status(:success)
  end
 end

end
