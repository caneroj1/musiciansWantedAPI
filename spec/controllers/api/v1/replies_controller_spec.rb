require 'rails_helper'

RSpec.describe Api::V1::RepliesController, type: :controller do
  describe 'GET #index' do
    context 'successful GET for index' do
      before(:each) do
        @message = FactoryGirl.create(:message_with_replies)
        get :index, { message_id: @message.id }, format: :json
      end

      it 'should return all of the replies for a given message' do
        expect(json_response.count).to eq(@message.replies.count)
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end

      it 'should return an array of hashes' do
        expect(json_response.first.class).to eq(Hash)
      end

      it 'should contain data' do
        first_reply = json_response.first
        expect(first_reply[:body]).to_not eq(nil)
      end
    end

    context 'successful GET with no replies' do
      before(:each) do
        @message = FactoryGirl.create(:message)
        get :index, { message_id: @message.id }, format: :json
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end

      it 'should return an empty array' do
        expect(json_response).to be_empty
      end
    end

    context 'unsuccessful GET' do
      context 'message does not exist' do
        before(:each) do
          get :index, { message_id: -1 }, format: :json
        end

        it 'should respond with 422' do
          expect(response.status).to eq(422)
        end

        it 'should return errors' do
          expect(json_response).to have_key(:errors)
        end

        it 'should say what happened' do
          expect(json_response[:errors]).to eq("message does not exist")
        end
      end
    end
  end

  describe 'GET #show' do
    context 'successful GET' do
      before(:each) do
        message = FactoryGirl.create(:message_with_replies)
        reply = message.replies.first
        get :show, { message_id: message.id, id: reply.id }, format: :json
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end

      it 'should respond with json' do
        expect(json_response).to have_key(:body)
      end

      it 'should be a hash' do
        expect(json_response[:body]).to_not eq(nil)
      end
    end

    context 'unsuccessful GET' do
      context 'message does not exist' do
        before(:each) do
          message = FactoryGirl.create(:message_with_replies)
          reply = message.replies.first
          get :show, { message_id: -1, id: reply.id }, format: :json
        end

        it 'should respond with 422' do
          expect(response.status).to eq(422)
        end

        it 'should have an errors key' do
          expect(json_response).to have_key(:errors)
        end

        it 'should explain the problem' do
          expect(json_response[:errors]).to eq("message does not exist")
        end
      end

      context 'reply does not exist' do
        before(:each) do
          message = FactoryGirl.create(:message_with_replies)
          reply = message.replies.first
          get :show, { message_id: message.id, id: -1 }, format: :json
        end

        it 'should respond with 422' do
          expect(response.status).to eq(422)
        end

        it 'should have an errors key' do
          expect(json_response).to have_key(:errors)
        end

        it 'should explain the problem' do
          expect(json_response[:errors]).to eq("reply not found")
        end
      end
    end
  end

  describe 'POST #create' do
    context 'successful creation' do
      before(:each) do
        @message = FactoryGirl.create(:message)
        @reply_count = Reply.count
        @message_replies = @message.replies.count
        post :create, { message_id: @message.id, reply: FactoryGirl.attributes_for(:reply) }, format: :json
      end

      it 'should create a new reply' do
        expect(Reply.count).to eq(@reply_count + 1)
      end

      it 'should return a hash of the created reply' do
        expect(json_response).to have_key(:body)
      end

      it 'should respond with 201' do
        expect(response.status).to eq(201)
      end

      it 'should add the reply to the specified message' do
        expect(@message.replies.count).to eq(@message_replies + 1)
      end
    end

    context 'unsuccessful creation' do
      context 'invalid attributes' do
        before(:each) do
          @message = FactoryGirl.create(:message)
          @reply_count = Reply.count
          reply_attributes = FactoryGirl.attributes_for :reply, body: nil
          post :create, { message_id: @message.id, reply: reply_attributes }, format: :json
        end

        it 'should respond with 422' do
          expect(response.status).to eq(422)
        end

        it 'should not change the total number of replies' do
          expect(Reply.count).to eq(@reply_count)
        end

        it 'should return errors in json' do
          expect(json_response).to have_key(:errors)
        end

        it 'should be informative with the errors' do
          expect(json_response[:errors][:body]).to include("can't be blank")
        end
      end

      context 'invalid message' do
        before(:each) do
          @reply_count = Reply.count
          post :create, { message_id: -1, reply: FactoryGirl.attributes_for(:reply) }, format: :json
        end

        it 'should not change the total number of replies' do
          expect(Reply.count).to eq(@reply_count)
        end

        it 'should return errors in json' do
          expect(json_response).to have_key(:errors)
        end

        it 'should be informative with the errors' do
          expect(json_response[:errors]).to include("message does not exist")
        end

        it 'should respond with 422' do
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'success' do
      before(:each) do
        @message = FactoryGirl.create(:message_with_replies)
        @reply_count = @message.replies.count
        @reply = @message.replies.first
        delete :destroy, { id: @reply.id, message_id: @message.id }, format: :json
      end

      it 'should delete the reply' do
        expect(@message.replies.count).to eq(@reply_count - 1)
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end

      it 'should respond with info' do
        expect(json_response[:info]).to eq("delete successful")
      end
    end

    context 'not successful' do
      context 'message cannot be found' do
        before(:each) do
          @reply_count = Reply.count
          delete :destroy, { id: 0, message_id: -1 }, format: :json
        end

        it 'should not change the reply count' do
          expect(Reply.count).to eq(@reply_count)
        end

        it 'should respond with 422' do
          expect(response.status).to eq(422)
        end

        it 'should have errors' do
          expect(json_response).to have_key(:errors)
        end

        it 'should say what happened' do
          expect(json_response[:errors]).to eq("message does not exist")
        end
      end

      context 'reply does not exist' do
        before(:each) do
          @message = FactoryGirl.create(:message_with_replies)
          @reply_count = @message.replies.count
          delete :destroy, { id: -1, message_id: @message.id }, format: :json
        end

        it 'should not change the reply count' do
          expect(@message.replies.count).to eq(@reply_count)
        end

        it 'should respond with 422' do
          expect(response.status).to eq(422)
        end

        it 'should have errors' do
          expect(json_response).to have_key(:errors)
        end

        it 'should say what happened' do
          expect(json_response[:errors]).to eq("delete unsuccessful")
        end
      end
    end
  end
end
