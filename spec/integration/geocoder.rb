require 'rails_helper'

Geocoder.configure(:lookup => :test)

Geocoder::Lookup::Test.add_stub(
  "New York, NY", [
    {
      'latitude'     => 40.7143528,
      'longitude'    => -74.0059731,
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)

RSpec.describe "Geocoder" do
  it 'should be able to search by location' do
    expect(Geocoder.search('New York, NY')).to_not be_empty
  end
end
