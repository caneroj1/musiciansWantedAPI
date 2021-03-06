FactoryGirl.define do
  factory :message do
    subject { FFaker::Company.catch_phrase }
    body    { FFaker::Lorem.sentence }

    factory :message_with_replies do
      after(:create) do |message|
        5.times { message.replies << FactoryGirl.create(:reply) }
      end
    end
  end

end
