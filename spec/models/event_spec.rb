require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { FactoryGirl.create(:event) }
  before(:each) { puts event.inspect }
  describe 'factory' do
    it 'is valid' do
      expect(FactoryGirl.build(:event)).to be_valid
    end
  end

  context 'attributes' do
    it 'has a title' do
      expect(event.title).to_not be_blank
    end

    it 'requires a title' do
      expect(FactoryGirl.build(:event, title: nil)).to_not be_valid
    end

    it 'has a location' do
      expect(event.location).to_not be_blank
    end

    it 'requires a location' do
      expect(FactoryGirl.build(:event, location: nil)).to_not be_valid
    end

    it 'has an event_time' do
      expect(event.event_time).to_not be_blank
    end

    it 'requires an event_time' do
      expect(FactoryGirl.build(:event, event_time: nil)).to_not be_valid
    end
  end
end
