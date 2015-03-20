FactoryGirl.define do
  factory :event do
    location { FakerSupport.location }
    title { FakerSupport.event_name }
    event_time { FFaker::Time.date }
    created_by { rand(100) }

    factory :event_with_attendees do
      after(:create) do |event|
        5.times do
          event.users << FactoryGirl.create(:user)
        end
      end
    end
  end
end
