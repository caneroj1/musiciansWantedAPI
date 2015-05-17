require 'ffaker'

class FakerSupport
  class << self
    def location
      "#{FFaker::AddressUS.street_address}, #{FFaker::AddressUS.city}, #{FFaker::AddressUS.state} #{FFaker::AddressUS.zip_code}"
    end

    def event_name
      "#{adjective} #{FFaker::Color.name.capitalize} #{event_type}"
    end

    def description
      "#{FFaker::HipsterIpsum.paragraph}"
    end

    def instrument
      instruments.sample
    end

    def request_notification
      "#{FFaker::Name.name} is looking for a #{instrument}"
    end

    private
    def event_type
      %w{Hoedown She-bang Hootenanny Party Event Gala Ball Masquerade}.sample
    end

    def adjective
      %w{Amazing Ridiculous Super Fun Extravagant Exquisite Dashing Baller
         Enlightening Lively Sweet}.sample
    end

    def instruments
      %w{drummer guitarist bassist vocalist pianist keyboardist percussionist }
    end
  end
end
