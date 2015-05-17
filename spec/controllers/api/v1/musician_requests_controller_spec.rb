require 'rails_helper'

RSpec.describe Api::V1::MusicianRequestsController, type: :controller do
  describe 'POST #create' do
    context 'successful' do
      let(:user) { FactoryGirl.create(:user_with_location) }

      before(:each) do
        @notification_count = Notification.count
        @musician_request_attributes = FactoryGirl.attributes_for(:musician_request)
        post :create, { musician_request: @musician_request_attributes, user_id: user.id }
      end

      it 'should respond with 201' do
        expect(response.status).to eq(201)
      end

      it 'should return json for the musician request just created' do
        expect(json_response.class).to eq(Hash)
      end

      it 'should have a poster with the same name as the user' do
        expect(json_response[:poster]).to eq(user.name)
      end

      it 'should create a new notification' do
        expect(Notification.count).to be > @notification_count
      end
    end

    context 'unsuccessful' do
      let(:user) { FactoryGirl.create(:user) }

      before(:each) do
        post :create, { musician_request: {}, user_id: user.id }
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end

      it 'should have an errors key' do
        expect(json_response).to have_key(:errors)
      end
    end
  end
end
