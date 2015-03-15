require 'ffaker'

class FakerSupport
  class << self
    def location
      "#{Faker::AddressUS.street_address}, #{Faker::AddressUS.city}, #{Faker::AddressUS.state} #{Faker::AddressUS.zip_code}"
    end
  end
end
