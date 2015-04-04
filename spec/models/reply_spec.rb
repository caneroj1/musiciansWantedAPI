require 'rails_helper'

RSpec.describe Reply, type: :model do
  context 'factory' do
    it 'should have a valid factory' do
      expect(FactoryGirl.build(:reply)).to be_valid
    end
  end

  context 'attributes' do
    let(:reply) { FactoryGirl.create(:reply) }

    it 'should have a body' do
      expect(reply.body).to_not eq(nil)
    end

    it 'requires a body' do
      expect(FactoryGirl.build(:reply, body: nil)).to_not be_valid
    end
  end

  context 'associations' do
    it { should belong_to :message }
  end
end
