require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  describe 'GET #index' do
    before(:each) do
      get :index, format: :json
    end

    it 'returns all of the users' do
      user_response = json_response
      expect(user_response.count).to eq(User.count)
    end

    it 'should return 200 on a valid request' do
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it 'returns the information in a hash' do
      user_response = json_response
      expect(user_response[:name]).to eq(@user.name)
    end

    it 'should return 200 on a valid request' do
      expect(response.status).to eq(200)
    end
  end

  describe 'POST #create' do
    context "when successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }, format: :json
      end

      it 'renders json for the record that was just created' do
        user_response = json_response
        expect(user_response[:name]).to eq(@user_attributes[:name])
      end

      it 'should respond with 201 for a successful create' do
        expect(response.status).to eq(201)
      end
    end

    context "when is not created" do
      before(:each) do
        @user_attributes = { }
        post :create, { user: @user_attributes }, format: :json
        @user_response = json_response
      end

      it 'renders an errors json' do
        expect(@user_response).to have_key(:errors)
      end

      it 'renders the errors json on why the user could not be created' do
        expect(@user_response[:errors][:name]).to include("can't be blank")
      end

      it 'should respond with 422 error code' do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context "when is successfully updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id, user: { name: "New Name" } }, format: :json
      end

      it 'renders the json representation for a successfully updated user' do
        user_attributes = json_response
        expect(user_attributes[:name]).to eq("New Name")
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end
    end

    context "when is not successful" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id, user: { name: "" } }, format: :json
      end

      it 'renders an errors json' do
        user_attributes = json_response
        expect(user_attributes).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        user_attributes = json_response
        expect(user_attributes[:errors][:name]).to include("can't be blank")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end
  end
end
