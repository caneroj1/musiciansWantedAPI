namespace :mw do
  desc "Generates API Documentation"
  task :document do
    API::Routes.document('/api', File.join(Rails.root, "app/views/welcome/index.html.erb"))
  end

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

  desc "changes all of the passwords in the db to one you specify"
  task passwords: :environment do
    puts "This task will change the password of EVERY user in the database."
    puts "Are you sure you want to continue? (yes/no)"
    continue = STDIN.gets.chomp.strip

    if continue.eql?("yes")
      puts "A valid password must contain at least 1 number, 1 letter, and be at least 8 characters long."
      print("Enter new password: ")
      new_password = STDIN.gets.chomp.strip
      User.all.each { |user| puts "Updated User with id = #{user.id}: #{user.update(password: new_password, password_confirmation: new_password)}" }
    end
  end
end
