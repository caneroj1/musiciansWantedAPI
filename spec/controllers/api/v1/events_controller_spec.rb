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
end
