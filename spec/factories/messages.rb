FactoryGirl.define do
  factory :message do
    subject { FFaker::Company.catch_phrase }
    body { FFaker::Lorem.sentence }
  end

end
