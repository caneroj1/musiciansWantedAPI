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

  describe 'GET #get_event_attendees' do
    context 'event exists' do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @event = FactoryGirl.create(:event_with_attendees, created_by: @user.id)

        get :get_event_attendees, { id: @event.id }, format: :json
      end

      it 'should return all of the users attending the event' do
        users_attending = json_response
        expect(users_attending.count).to eq(@event.users.count)
      end

      it 'should return json' do
        user_response = json_response
        expect(user_response[0][:name]).to_not be_blank
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'event does not exist' do
      before(:each) do
        @user = FactoryGirl.create(:user)

        get :get_event_attendees, { id: -1 }, format: :json
      end

      it 'should render a json with errors' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it 'should say request was unsuccessful' do
        user_response = json_response
        expect(user_response[:errors]).to include("unsuccessful")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'GET #get_event_creator' do
    context 'event exists' do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @event = FactoryGirl.create(:event, created_by: @user.id)

        get :get_event_creator, { id: @event.id }, format: :json
      end

      it 'should return json for the user' do
        user_response = json_response
        expect(user_response).to have_key(:name)
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'event does not exist' do
      before(:each) do
        @user = FactoryGirl.create(:user)

        get :get_event_creator, { id: -1 }, format: :json
      end

      it 'should return an errors json indicating there was a problem' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it 'should say the request was unsuccessful' do        user_response = json_response
        user_response = json_response
        expect(user_response[:errors]).to include("unsuccessful")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'POST #attend_event' do
    context 'user not already attending' do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @event = FactoryGirl.create(:event)

        post :attend_event, { id: @event.id, user_id: @user.id }, format: :json
      end

      it 'should add the user to the list of attendees' do
        @event.reload
        expect(@event.users).to include(@user)
      end

      it 'should respond with 204' do
        expect(response.status).to eq(204)
      end
    end

    context 'user already attending' do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @event = FactoryGirl.create(:event)
        @event.users << @user
        @attendee_count = @event.users.count

        post :attend_event, { id: @event.id, user_id: @user.id }, format: :json
      end

      it 'should not add the user to the list of attendees' do
        expect(@attendee_count).to eq(@event.users.count)
      end

      it 'should render an errors json indicating there was a problem' do
        event_response = json_response
        expect(event_response).to have_key(:errors)
      end

      it 'should said a problem occurred' do
        event_response = json_response
        expect(event_response[:errors]).to include("problem")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end

    context 'event does not exist' do
      before(:each) do
        @user = FactoryGirl.create(:user)

        post :attend_event, { id: -1, user_id: @user.id }, format: :json
      end

      it 'should render an errors json indicating there was a problem' do
        event_response = json_response
        expect(event_response).to have_key(:errors)
      end

      it 'should say there was a problem' do
        event_response = json_response
        expect(event_response[:errors]).to include("problem")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end

    context 'user does not exist' do
      before(:each) do
        @event = FactoryGirl.create(:event)

        post :attend_event, { id: @event.id, user_id: -1 }, format: :json
      end

      it 'should render an errors json indicating there was a problem' do
        event_response = json_response
        expect(event_response).to have_key(:errors)
      end

      it 'should say there was a problem' do
        event_response = json_response
        expect(event_response[:errors]).to include("problem")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end
  end
end
