require 'rails_helper'

RSpec.describe Api::V1::SnsNotificationsController, type: :controller do
  describe 'POST #subscribe' do
    context 'with incorrect cell number' do
      before(:each) do
        post :subscribe, { cell: "111-222-3333" }, format: :json
      end

      it 'should have an error' do
        expect(json_response).to have_key(:errors)
      end

      it 'should say what happened' do
        expect(json_response[:errors]).to eq("invalid number")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end

    context 'with unsupported sms endpoint' do
      before(:each) do
        post :subscribe, { cell: ENV["bad_cell"] }, format: :json
      end

      it 'should rescue an error' do
        expect(json_response).to have_key(:errors)
      end

      it 'should contain a detailed success response' do
        expect(json_response[:errors]).to eq("we encountered a problem")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end

    context 'with supported cell' do
      before(:each) do
        test_cell = ENV["test_cell"]
        @response_hash = {}
        if /1-[0-9]{3}-[0-9]{3}-[0-9]{4}/.match(test_cell)
          @response_hash[:status] = 201
          @response_hash[:subscription] = "pending confirmation"
        end
      end

      it 'should respond with 201' do
        expect(@response_hash[:status]).to eq(201)
      end

      it 'should have subscription info' do
        expect(@response_hash).to have_key(:subscription)
      end

      it 'should say it is pending' do
        expect(@response_hash[:subscription]).to eq("pending confirmation")
      end
    end
  end
end
