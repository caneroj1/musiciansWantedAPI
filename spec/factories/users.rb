require_relative '../support/faker_support'

FactoryGirl.define do
  factory :user do
    name                    { FFaker::Name.name }
    email                   { FFaker::Internet.email }
    age                     { rand(40) + 10 }
    gender                  { %w{male female none}.sample }
    cell                    { "" }
    password                { "password" }
    password_confirmation   { "password" }

    factory :user_with_events do
      after(:create) do |user|
        5.times do
          event = FactoryGirl.create(:event, created_by: user.id)
          event.users << user
        end
      end
    end

    factory :user_with_messages do
      after(:create) do |user|
        5.times { FactoryGirl.create(:message, sent_by: user.id) }
      end
    end

    factory :user_with_received_messages do
      after(:create) do |user|
        5.times { FactoryGirl.create(:message, user_id: user.id) }
      end
    end

    factory :user_with_location do
      location { 'New York, NY' }
    end

    factory :user_with_contacts do
      after(:create) do |user|
        5.times do
          contact = FactoryGirl.create(:user, cell: "")
          FactoryGirl.create(:contactship, user_id: user.id, contact_id: contact.id)
        end
      end
    end

    factory :user_attending_events do
      id = FactoryGirl.create(:user).id
      after(:create) do |user|
        user.events << Event.new(title: "test", location: "test", event_time: Time.now, description: "test", created_by: id)
      end
    end
  end
end
