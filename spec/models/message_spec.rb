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

    it 'requires a subject' do
      expect(FactoryGirl.build(:message, subject: nil)).to_not be_valid
    end

    it 'requires a body' do
      expect(FactoryGirl.build(:message, body: nil)).to_not be_valid
    end
  end

  context 'associations' do
    it { should belong_to :user }
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
