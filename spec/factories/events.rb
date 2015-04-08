FactoryGirl.define do
  factory :event do
    title       { FakerSupport.event_name }
    event_time  { FFaker::Time.date }
    created_by  { rand(100) }
    location    { FakerSupport.location }

    factory :event_with_attendees do
      after(:create) do |event|
        5.times { event.users << FactoryGirl.create(:user) }
      end
    end
  end
end
