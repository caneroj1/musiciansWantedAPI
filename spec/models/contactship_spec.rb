require 'rails_helper'

RSpec.describe Contactship, type: :model do
  let(:contactship) { FactoryGirl.create(:contactship) }

  context 'attributes' do
    it 'has a user id' do
      expect(contactship.user_id).to_not be_nil
    end

    it 'has a contact id' do
      expect(contactship.contact_id).to_not be_nil
    end
  end

  context 'associations' do
    it { should belong_to :user }
  end
end
