require 'rails_helper'

RSpec.describe User do
  let(:user) { FactoryGirl.create(:user) }

  describe 'factory' do
    it 'is valid' do
      expect(FactoryGirl.build(:user)).to be_valid
    end
  end

  context 'attributes' do
    it 'has a name' do
      expect(user.name).to_not be_blank
    end

    it 'requires name' do
      expect(FactoryGirl.build(:user, name: nil)).to_not be_valid
    end

    it 'has an email address' do
      expect(user.email).to_not be_blank
    end

    it 'requires email' do
      expect(FactoryGirl.build(:user, email: nil)).to_not be_valid
    end

    it 'validates email correctly' do
      expect(FactoryGirl.build(:user, email: "email.com")).to_not be_valid
    end

    it 'has an age' do
      expect(user.age).to_not be_blank
    end

    it 'does not require age ' do
      expect(FactoryGirl.build(:user, age: nil)).to be_valid
    end

    it 'automatically converts float ages to integers' do
      expect(FactoryGirl.build(:user, age: 55.6)).to be_valid
    end

    it 'must have a positive age' do
      expect(FactoryGirl.build(:user, age: -1)).to_not be_valid
    end

    it 'has a location' do
      expect(FactoryGirl.build(:user).location).to_not be_blank
    end
  end
end
