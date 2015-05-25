require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:message) { FactoryGirl.create(:message) }

  describe 'factory' do
    it 'is valid' do
      expect(FactoryGirl.build(:message)).to be_valid
    end
  end

  context 'attributes' do
    it 'should have a subject' do
      expect(message.subject).to_not eq(nil)
    end

    it 'should have a body' do
      expect(message.body).to_not eq(nil)
    end

    it 'should have a receiver saw message attribute' do
      expect(message.seen_by_receiver).to_not be nil
    end

    it 'should have a sender saw message attribute' do
      expect(message.seen_by_sender).to_not be nil
    end

    it 'defaults seen by sender to false' do
      expect(message.seen_by_sender).to be false
    end

    it 'defaults seen by receiver to false' do
      expect(message.seen_by_receiver).to be false
    end

    it 'requires a subject' do
      expect(FactoryGirl.build(:message, subject: nil)).to_not be_valid
    end

    it 'requires a body' do
      expect(FactoryGirl.build(:message, body: nil)).to_not be_valid
    end
  end

  context 'associations' do
    it { should belong_to :user }
    it { should have_many :replies }
  end

  context 'instance methods' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @sent_message = FactoryGirl.create(:message, sent_by: @user.id)
    end

    it '#sender should return the user who sent the message' do
      expect(@sent_message.sender).to eq(@user)
    end
  end
end
