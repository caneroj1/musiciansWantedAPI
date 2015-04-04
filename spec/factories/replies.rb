FactoryGirl.define do
  factory :reply do
    body { FFaker::Lorem.sentence }
  end
end
