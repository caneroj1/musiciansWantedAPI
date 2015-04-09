require 'rails_helper'
require_relative '../../../support/notification_support'

RSpec.describe Api::V1::NotificationsController, type: :controller do
  describe '#GET notifications' do
    context 'existing user' do
      let(:user) { FactoryGirl.create(:user_with_location, location: "7th Ave Times Square, New York") }
      let(:search_radius) { user.search_radius }

      before(:each) do
        create_notifications(user)
        get :notifications, { id: user.id }, format: :json
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end

      it 'should return a list of close notifications' do
        expect(json_response.count).to be >= 1
      end

      it 'should have a distance in for each notification' do
        expect(json_response.first).to have_key(:distance)
      end

      it "should have a distance <= #{10}" do
        json_response.each do |item|
          expect(item[:distance]).to be <= 10
        end
      end
    end

    context 'nonexistent user' do
      before(:each) do
        get :notifications, { id: -1 }, format: :json
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end

      it 'should have an errors key' do
        expect(json_response).to have_key(:errors)
      end

      it 'should say what happened' do
        expect(json_response[:errors]).to eq("user does not exist")
      end
    end
  end
end
