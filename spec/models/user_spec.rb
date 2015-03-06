require 'rails_helper'

RSpec.describe User do
  let(:user) { FactoryGirl.create(:user) }

  context 'attributes' do
    it 'has a name' do
      expect(user.name).to_not be_blank
    end
  end
end
