FactoryGirl.define do
  factory :musician_request do
    poster      { FFaker::Name.name }
    instrument  { FakerSupport.instrument }
    location    { FakerSupport.location }
  end
end
