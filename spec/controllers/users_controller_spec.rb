require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  describe "GET users" do

    before (:each) do
      @user1 = FactoryGirl.create :user
      @user2 = FactoryGirl.create(:user, username: "Dean")
      session[:user_id] = 1
    end

    it "can get index" do
      get :index
      expect(response).to render_template(:index)
      expect(assigns(:users)).to eq([@user1, @user2])
    end
  end

end
