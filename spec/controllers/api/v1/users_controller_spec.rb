require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  before(:each) { request.headers['Accepts'] = 'application/vnd.musicianswanted.v1' }

  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it "returns the information in a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:name]).to eq(@user.name)
    end

    it "should return 200 on a valid request" do
      expect(response.status).to eq 200
    end
  end
end
