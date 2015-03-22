require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  describe 'GET #index' do
    before(:each) do
      get :index, format: :json
    end

    it 'returns all of the users' do
      expect(json_response.count).to eq(User.count)
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
      expect(json_response[:name]).to eq(@user.name)
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
        expect(json_response[:name]).to eq(@user_attributes[:name])
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
        expect(json_response[:name]).to eq("New Name")
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
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors][:name]).to include("can't be blank")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end

    context "when it cannot find the user" do
      it 'has errors' do
        patch :update, { id: -1 }
        expect(json_response).to have_key(:errors)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'on successful destroy' do
      before(:each) do
        @user = FactoryGirl.create(:user)
        delete :destroy, { id: @user.id }, format: :json
      end

      it 'should delete the user' do
        expect(User.find_by_id(@user.id)).to eq(nil)
      end

      it 'should return a string indicating delete worked' do
        expect(json_response[:info]).to eq("delete successful")
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'on unsuccessful destroy' do
      before(:each) do
        @user_count = User.count
        delete :destroy, { id: -1 }, format: :json
      end

      it 'should not delete a user' do
        expect(User.count).to eq(@user_count)
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end

      it 'should have an errors key indicating what went wrong' do
        expect(json_response).to have_key(:errors)
      end

      it 'should render the errors' do
        expect(json_response[:errors]).to include("unsuccessful")
      end
    end
  end

  describe 'GET #get_events' do
    context 'user exists' do
      before(:each) do
        @user = FactoryGirl.create(:user_with_events)
        @event_count = @user.events.count
        get :get_events, { id: @user.id }, format: :json
      end

      it 'should return all of the user\'s events' do
        user_response = json_response
        expect(user_response.count).to eq(@event_count)
      end

      it 'should return them in json hash format' do
        user_response = json_response
        expect(user_response[0][:title]).to_not be_blank
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'user does not exist' do
      before(:each) do
        get :get_events, { id: -1 }, format: :json
      end

      it 'should return an errors json indicating there was a problem' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it 'should say that there was a problem' do
        user_response = json_response
        expect(user_response[:errors]).to include("problem")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end
  end
end
