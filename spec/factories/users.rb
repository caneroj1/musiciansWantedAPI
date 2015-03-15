require_relative '../support/faker_support'

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    age { rand(40) + 10 }
    location { FakerSupport.location }
  end
end
