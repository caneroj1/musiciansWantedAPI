require_relative '../support/faker_support'

FactoryGirl.define do
  factory :user do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    age { rand(40) + 10 }
    location { FakerSupport.location }

    factory :user_with_events do
      after(:create) do |user|
        5.times { user.events << FactoryGirl.create(:event) }
      end
    end

    factory :user_with_messages do
      after(:create) do |user|
        5.times { FactoryGirl.create(:message, sent_by: user.id) }
      end
    end
  end
end
