require 'rails_helper'

RSpec.describe Api::V1::RepliesController, type: :controller do
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
