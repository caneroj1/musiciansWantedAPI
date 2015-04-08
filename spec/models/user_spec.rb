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

    it 'needs a unique email' do
      expect { FactoryGirl.create(:user, email: user.email) }.to raise_error
    end

    context 'email validation' do
      it 'needs an @' do
        expect(FactoryGirl.build(:user, email: "email.com")).to_not be_valid
      end

      it 'cannot start with an @' do
        expect(FactoryGirl.build(:user, email: "@email@mail.com")).to_not be_valid
      end

      it 'cannot start a space' do
        expect(FactoryGirl.build(:user, email: " email@mail.com")).to_not be_valid
      end

      it 'cannot have a single-letter top-level domain' do
        expect(FactoryGirl.build(:user, email: "email@mail.c")).to_not be_valid
      end

      it 'approves well-formed emails' do
        expect(FactoryGirl.build(:user, email: "my.email@mail.com")).to be_valid
      end
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
      expect(FactoryGirl.build(:user_with_location).location).to_not be_nil
    end

    it 'can be looking for a band' do
      expect(user.looking_for_band).to_not be_nil
    end

    it 'can be looking to jam' do
      expect(user.looking_to_jam).to_not be_nil
    end

    it 'defaults looking for band to false' do
      expect(user.looking_for_band).to eq(false)
    end

    it 'defaults looking to jam to false' do
      expect(user.looking_to_jam).to eq(false)
    end

    it 'defaults has a profile picture to false' do
      expect(user.has_profile_pic).to eq(false)
    end

    it 'has a search radius' do
      expect(user.search_radius).to_not eq(nil)
    end

    it 'defaults search radius to 10 miles' do
      expect(user.search_radius).to eq(10)
    end

    it 'cannot have search radius less than 5' do
      expect(FactoryGirl.build(:user, search_radius: 4)).to_not be_valid
    end

    it 'cannot have search radius more than 20' do
      expect(FactoryGirl.build(:user, search_radius: 21)).to_not be_valid
    end

    it 'can have gender' do
      expect(user.gender).to_not be_blank
    end

    it 'can have a male gender' do
      expect(FactoryGirl.build(:user, gender: "male")).to be_valid
    end

    it 'can have a female gender' do
      expect(FactoryGirl.build(:user, gender: "female")).to be_valid
    end

    it 'cannot have blank genders' do
      expect(FactoryGirl.build(:user, gender: "")).to_not be_valid
    end
  end

  context 'associations' do
    it { should have_and_belong_to_many :events }
    it { should have_many :messages }
  end

  context 'instance methods' do
    let(:user) { FactoryGirl.create(:user_with_messages) }

    it '#sent_messages should return every message a user sent' do
      expect(user.sent_messages.count).to eq(5)
    end
  end
end
