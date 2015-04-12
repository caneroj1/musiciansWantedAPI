FactoryGirl.define do
  factory :notification do
    title                 { FakerSupport.event_name }
    location              { FakerSupport.location }
    notification_type     { [0, 1].sample }
    record_id             { rand(100) + 1 }

    factory :event_notification do
      title              { FakerSupport.event_name }
      notification_type  { 0 }
    end

    factory :user_notification do
      title              { FFaker::Name.name }
      notification_type  { 1 }
    end
  end
end