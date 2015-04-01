require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST#login' do
    context 'with appropriate credentials' do
      before(:each) do
        post :login, { username: ENV["soundcloud_username"],
                       password: ENV["soundcloud_password"] }, format: :json
        @login_response = json_response
      end

      it 'will return json for soundcloud' do
        expect(@login_response).to have_key(:refresh_token)
      end

      it 'will return the user id for the correct user' do
        expect(@login_response).to have_key(:user_id)
      end
    end
  end
end
