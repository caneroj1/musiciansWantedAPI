require 'ffaker'

class FakerSupport
  class << self
    def location
      "#{Faker::AddressUS.street_address}, #{Faker::AddressUS.city}, #{Faker::AddressUS.state} #{Faker::AddressUS.zip_code}"
    end

    def event_name
      "#{adjective} #{Faker::Color.name.capitalize} #{event_type}"
    end

    private
    def event_type
      %w{Hoedown She-bang Hootenanny Party Event Gala Ball Masquerade}.sample
    end

    def adjective
      %w{Amazing Ridiculous Super Fun Extravagant Exquisite Dashing Baller
         Enlightening Lively Sweet}.sample
    end
  end
end
