require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      get :index, format: :json
    end

    it 'returns all of the events' do
      event_response = json_response
      expect(event_response.count).to eq(Event.count)
    end

    it 'should return 200 on a valid request' do
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    before(:each) do
      @event = FactoryGirl.create :event
      get :show, id: @event, format: :json
    end

    it 'returns the information in a hash' do
      event_response = json_response
      expect(event_response[:title]).to eq(@event.title)
    end

    it 'should return 200 on a valid request' do
      expect(response.status).to eq(200)
    end
  end

  describe 'POST #create' do
    context "when successfully created" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @event_attributes = FactoryGirl.attributes_for :event, created_by: @user.id
        post :create, { event: @event_attributes }, format: :json
        @event_response = json_response
      end

      it 'renders json for the record that was just created' do
        expect(@event_response[:title]).to eq(@event_attributes[:title])
      end

      it 'should respond with 201 for a successful create' do
        expect(response.status).to eq(201)
      end

      it 'should create an event that belongs to the correct user' do
        expect(@event_response[:created_by]).to eq(@user.id)
      end
    end

    context 'when is not created' do
      before(:each) do
        @event_attributes = { }
        post :create, { event: @event_attributes }, format: :json
        @event_response = json_response
      end

      it 'renders an errors json' do
        expect(@event_response).to have_key(:errors)
      end

      it 'renders the errors json on why the creation failed' do
        expect(@event_response[:errors][:title]).to include("can't be blank")
      end

      it 'should respond with 422 error code' do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when is successfully updated' do
      before(:each) do
        @event = FactoryGirl.create(:event)
        patch :update, { id: @event.id, event: { title: "Super Pool Party"} }, format: :json
      end

      it 'renders the json representation for a successful update' do
        event_attributes = json_response
        expect(event_attributes[:title]).to eq("Super Pool Party")
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'when is not successful' do
      before(:each) do
        @event = FactoryGirl.create(:event)
        patch :update, { id: @event.id, event: { title: "" } }
      end

      it 'renders an errors json' do
        user_attributes = json_response
        expect(user_attributes).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not update' do
        user_attributes = json_response
        expect(user_attributes[:errors][:title]).to include("can't be blank")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end

    context 'when it cannot find the event' do
      it 'has errors' do
        patch :update, { id: -1 }, format: :json
        expect(json_response).to have_key(:errors)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'on successful destroy' do
      before(:each) do
        @event = FactoryGirl.create(:event)
        delete :destroy, { id: @event.id }, format: :json
      end

      it 'should delete an event' do
        expect(Event.find_by_id(@event.id)).to eq(nil)
      end

      it 'should return a string indicating the delete was successful' do
        expect(json_response[:info]).to eq("delete successful")
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'on unsuccessful destroy' do
      before(:each) do
        @event_count = Event.count
        delete :destroy, { id: -1 }, format: :json
      end

      it 'should not delete an event' do
        expect(Event.count).to eq(@event_count)
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end

      it 'should have an errors key indicating something went wrong' do
        expect(json_response).to have_key(:errors)
      end

      it 'should render an errors json' do
        expect(json_response[:errors]).to eq("delete unsuccessful")
      end
    end
  end
end
