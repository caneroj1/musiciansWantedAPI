FactoryGirl.define do
  factory :notification do
    title    { FakerSupport.event_name }
    location { FakerSupport.location }
    type     { [0, 1].sample }

    factory :event_notification do
      title { FakerSupport.event_name }
      type  { 0 }
    end

    factory :user_notification do
      title { FFaker::Name.name }
      type  { 1 }
    end
  end
end
