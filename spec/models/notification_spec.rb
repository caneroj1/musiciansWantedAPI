require 'rails_helper'

RSpec.describe Notification, type: :model do
  context 'attributes' do
    let(:notification) { FactoryGirl.create(:notification) }

    it 'has a title' do
      expect(notification.title).to_not be_blank
    end

    it 'has a location' do
      expect(notification.location).to_not be_blank
    end
  end

  context 'event notification type' do
    before(:each) do
      @attributes = FactoryGirl.attributes_for(:event_notification)
      @event_notification = FactoryGirl.create(:event_notification, @attributes)
    end

    it 'has a proper title' do
      expect(@event_notification.title).to eq("Event: #{@attributes[:title]} was created.")
    end

    it 'has the correct type' do
      expect(@event_notification.notification_type).to eq(0)
    end
  end

  context 'user notification type' do
    before(:each) do
      @attributes = FactoryGirl.attributes_for(:user_notification)
      @user_notification = FactoryGirl.create(:user_notification, @attributes)
    end

    it 'has a proper title' do
      expect(@user_notification.title).to eq("#{@attributes[:title]} created an account.")
    end

    it 'has the correct type' do
      expect(@user_notification.notification_type).to eq(1)
    end
  end

  context 'creation' do
    it 'is created when a new user is created' do
      expect { FactoryGirl.create(:user) }.to change(Notification, :count).by 1
    end

    it 'is created when a new event is created' do
      expect { FactoryGirl.create(:event) }.to change(Notification, :count).by 1
    end
  end
end
