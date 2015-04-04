namespace :mw do
  desc "Generates fake data to fill up our db."
  task make_data: :environment do
    puts "Populating User Table"
    100.times { User.create(FactoryGirl.attributes_for(:user)) }
    puts "made 100 new users"

    puts "Populating Event Table"
    100.times { Event.create(FactoryGirl.attributes_for(:event, created_by: User.order("RANDOM()").first.id)) }
    puts "made 100 new events"

    puts "Making some users attend events"
    Event.last(100).each do |event|
      rand(30).times { event.users << User.order("RANDOM()").first }
    end
    puts "done"

    puts "Making messages"
    User.all.each do |user|
      5.times do
        user.messages << Message.new(FactoryGirl.attributes_for(:message,  user_id: user.id, sent_by: User.order("RANDOM()").first.id))
      end
    end
    puts "done"

    puts "Creating replies"
    Message.all.each do |message|
      receiver = message.user_id
      sender = message.sent_by
      (0..rand(5)).each { message.replies << Reply.new(FactoryGirl.attributes_for(:reply, user_id: (rand(100) < 50) ? receiver : sender )) }
    end
    puts "done"
  end
end
