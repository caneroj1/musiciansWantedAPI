require_relative '../support/faker_support'

FactoryGirl.define do
  factory :user do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    age { rand(40) + 10 }
    location { FakerSupport.location }
  end
end
