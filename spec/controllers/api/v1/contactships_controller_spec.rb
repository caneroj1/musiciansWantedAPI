require 'rails_helper'

RSpec.describe Api::V1::ContactshipsController, type: :controller do
  describe 'GET #contacts' do
    context 'with a correct user id' do
      before(:each) do
        @user = FactoryGirl.create(:user_with_contacts, cell: "")
        get :contacts, { user_id: @user.id }, format: :json
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
        get :contacts, { user_id: -1 }, format: :json
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

  describe 'POST #create' do
    context 'new contactship' do
      before(:each) do
        user = FactoryGirl.create(:user, cell: "")
        contact = FactoryGirl.create(:user, cell: "")
        post :create, { user_id: user.id, contact_id: contact.id }, format: :json
      end

      it 'should respond with 201' do
        expect(response.status).to eq(201)
      end

      it 'should return the created contactship' do
        expect(json_response).to have_key(:contact_id)
      end
    end

    context 'existing contactship' do
      before(:each) do
        user = FactoryGirl.create(:user, cell: "")
        contact = FactoryGirl.create(:user, cell: "")
        user.contactships << Contactship.new(user_id: user.id, contact_id: contact.id)
        post :create, { user_id: user.id, contact_id: contact.id }, format: :json
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end

      it 'should have an errors key' do
        expect(json_response).to have_key(:errors)
      end

      it 'should say what happened' do
        expect(json_response[:errors][:contact_id]).to include("already exists")
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'contactship exists' do
      before(:each) do
        @user = FactoryGirl.create(:user, cell: "")
        contact = FactoryGirl.create(:user, cell: "")
        @user.contactships << Contactship.new(user_id: @user.id, contact_id: contact.id)
        @contactship_count = @user.contactships.count
        delete :destroy, { user_id: @user.id, contact_id: contact.id }, format: :json
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end

      it 'should say it was a successful operation' do
        expect(json_response[:info]).to include("success")
      end

      it 'should delete the contactship' do
        @user.reload
        expect(@user.contactships.count).to eq(@contactship_count - 1)
      end
    end

    context 'contactship does not exist' do
      before(:each) do
        @user = FactoryGirl.create(:user, cell: "")
        contact = FactoryGirl.create(:user, cell: "")
        @user.contactships << Contactship.new(user_id: @user.id, contact_id: contact.id)
        @contactship_count = @user.contactships.count
        delete :destroy, { user_id: @user.id, contact_id: -1 }, format: :json
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end

      it 'should have errors' do
        expect(json_response).to have_key(:errors)
      end

      it 'should say what the errors are' do
        expect(json_response[:errors]).to eq("contact does not exist")
      end

      it 'should not delete the contactship' do
        @user.reload
        expect(@user.contactships.count).to eq(@contactship_count)
      end
    end
  end
end
