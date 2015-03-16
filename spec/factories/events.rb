FactoryGirl.define do
  factory :event do
    location { FakerSupport.location }
    title { FakerSupport.event_name }
    event_time { Faker::Time.date }
    created_by { rand(100) }
  end

end
