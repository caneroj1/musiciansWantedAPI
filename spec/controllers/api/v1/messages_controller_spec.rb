require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do
  describe 'PATCH #update' do
    context 'valid update' do
      before(:each) do
        @message = FactoryGirl.create :message
        @new_attributes = FactoryGirl.attributes_for(:message)
        patch :update, { message: @new_attributes, id: @message.id }, format: :json
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end

      it 'should return json of the new message' do
        expect(json_response.class).to eq(Hash)
      end

      it 'should contain the information' do
        expect(json_response[:subject]).to eq(@new_attributes[:subject])
      end
    end

    context 'invalid update' do
      before(:each) do
        @message = FactoryGirl.create :message
        patch :update, { message: { subject: "" }, id: @message.id }, format: :json
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end

      it 'should return errors' do
        expect(json_response).to have_key(:errors)
      end

      it 'should contain the information' do
        expect(json_response[:errors]).to_not be nil
      end
    end

    context 'nonexistent message' do
      before(:each) do
        patch :update, { id: -1 }, format: :json
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end

      it 'should return errors' do
        expect(json_response).to have_key(:errors)
      end

      it 'should say what happened' do
        expect(json_response[:errors]).to eq("something went wrong")
      end
    end
  end

  describe 'GET #show' do
    context 'with an existing message' do
      before(:each) do
        @message = FactoryGirl.create :message
        get :show, id: @message.id, format: :json
      end

      it 'returns the information in a hash' do
        expect(json_response[:subject]).to eq(@message.subject)
      end

      it 'should return 200 on a valid request' do
        expect(response.status).to eq(200)
      end
    end

    context 'with a nonexistent message' do
      before(:each) do
        get :show, id: -1, format: :json
      end

      it 'returns an error response' do
        expect(json_response).to have_key(:error)
      end

      it 'says the resource was not found' do
        expect(json_response[:error]).to eq("not found")
      end

      it 'should respond with 500' do
        expect(response.status).to eq(500)
      end
    end
  end

  describe 'POST #create' do
    context "when successfully created" do
      before(:each) do
        @sender = FactoryGirl.create(:user)
        @receiver = FactoryGirl.create(:user, cell: ENV["rspec_cell2"])
        @message_attributes = FactoryGirl.attributes_for :message, sent_by: @sender.id, user_id: @receiver.id
        @count = @receiver.messages.count
        post :create, { message: @message_attributes }, format: :json
      end

      it 'renders json for the record that was just created' do
        expect(json_response[:subject]).to eq(@message_attributes[:subject])
      end

      it 'should respond with 201 for a successful create' do
        expect(response.status).to eq(201)
      end

      it 'should add a new message to the receiver' do
        expect(@receiver.messages.count).to eq(@count + 1)
      end

      it 'should allow a message to be found by sender id' do
        expect(Message.find_by_sent_by(@sender.id)).to_not eq(nil)
      end
    end
  end

  context "when unsuccessfully created" do
    context "invalid message attributes" do
      before(:each) do
        @sender = FactoryGirl.create(:user)
        @receiver = FactoryGirl.create(:user, cell: ENV["rspec_cell2"])
        @message_attributes = FactoryGirl.attributes_for :message, subject: nil, sent_by: @sender.id, user_id: @receiver.id
        post :create, { message: @message_attributes }, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the errors on why the message could not be created' do
        expect(json_response[:errors][:subject]).to include("can't be blank")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end

    context "when user_id is incorrect" do
      before(:each) do
        @message_attributes = FactoryGirl.attributes_for :message
        post :create, { message: @message_attributes }, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the errors on why the message could not be created' do
        expect(json_response[:errors]).to include("problem")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with an existing message' do
      before(:each) do
        message = FactoryGirl.create(:message)
        @count = Message.count
        delete :destroy, id: message.id, format: :json
      end

      it 'should delete the message' do
        expect(json_response[:info]).to eq("delete successful")
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end

      it 'should have an info key' do
        expect(json_response).to have_key(:info)
      end

      it 'should change the number of messages' do
        expect(Message.count).to eq(@count - 1)
      end
    end

    context 'with a nonexistent message' do
      before(:each) do
        @count = Message.count
        delete :destroy, id: -1, format: :json
      end

      it 'should have an errors key' do
        expect(json_response).to have_key(:errors)
      end

      it 'should say the delete was unsuccessful' do
        expect(json_response[:errors]).to eq("delete unsuccessful")
      end

      it 'should respond with 422' do
        expect(response.status).to eq(422)
      end

      it 'should not change the number of messages' do
        expect(Message.count).to eq(@count)
      end
    end
  end
end
