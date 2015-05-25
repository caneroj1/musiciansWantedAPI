require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST#login' do
    context 'with appropriate credentials' do
      before(:each) do
        FactoryGirl.create(:user, name: "tester", email: "test_email@test.com", password: "tester12", password_confirmation: "tester12")
        post :login, { email: "test_email@test.com",
                       password: "tester12" }, format: :json
      end

      it 'will return an id for the user' do
        expect(json_response).to have_key(:user_id)
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'with incorrect credentials' do
      before(:each) do
        User.create(name: "tester", email: "test_email@test.com", password: "test", password_confirmation: "test")

        post :login, { email: "test_email@test.com",
                       password: "incorrect" }, format: :json
        @login_response = json_response
      end

      it 'will not have an id for the user' do
        expect(@login_response).to_not have_key(:user_id)
      end

      it 'will have an error' do
        expect(@login_response).to have_key(:errors)
      end

      it 'should say what went wrong' do
        expect(@login_response[:errors]).to include("username or password")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end
  end
end
