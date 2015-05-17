require 'rails_helper'

RSpec.describe MusicianRequest, type: :model do
  let(:request) { FactoryGirl.create(:musician_request) }

  context 'attributes' do
    it 'has a poster' do
      expect(request.poster).to_not eq(nil)
    end

    it 'has an instrument' do
      expect(request.instrument).to_not eq(nil)
    end

    it 'has a location' do
      expect(request.location).to_not eq(nil)
    end
  end
end
