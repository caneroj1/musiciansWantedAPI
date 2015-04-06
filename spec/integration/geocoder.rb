require 'rails_helper'

RSpec.describe "Geocoder" do
  it 'should be able to search by location' do
    expect(Geocoder.search('New York, NY')).to_not be_empty
  end
end
