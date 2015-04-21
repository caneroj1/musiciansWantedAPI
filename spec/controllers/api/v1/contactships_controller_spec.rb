require 'rails_helper'

RSpec.describe Api::V1::ContactshipsController, type: :controller do
  describe 'GET #index' do
    context 'with a passed in user id' do
      context 'with a correct user id' do
        before(:each) do
          @user = FactoryGirl.create(:user_with_contacts, cell: "")
          get :index, { id: @user.id }, format: :json
        end

        it 'should respond with 200' do
          expect(response.status).to eq(200)
        end

        it 'should return all of the contacts of the user' do
          expect(json_response.count).to eq(@user.contacts.count)
        end

        it 'should return users' do
          json_response.each { |response| expect(response[:name]).to_not be_nil }
        end

        it 'should be all unique' do
          expect(json_response.uniq.count).to eq(@user.contacts.count)
        end
      end

      context 'with an incorrect user id' do
        before(:each) do
          get :index, { id: -1 }, format: :json
        end

        it 'should return 422' do
          expect(response.status).to eq(422)
        end

        it 'should contain an error key' do
          expect(json_response).to have_key(:errors)
        end

        it 'should say what happened' do
          expect(json_response[:errors]).to include("does not exist")
        end
      end
    end

    context 'with no user id' do
      before(:each) do
        FactoryGirl.create(:contactship)
        get :index, format: :json
      end

      it 'should return all of the contact relationships' do
        expect(json_response.count).to eq(Contactship.count)
      end

      it 'should return 200' do
        expect(response.status).to eq(200)
      end

      it 'should have the information as json' do
        expect(json_response[0].class).to eq(Hash)
      end
    end
  end
end
