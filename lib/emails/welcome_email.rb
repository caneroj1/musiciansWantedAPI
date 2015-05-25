class Emails::WelcomeEmail
  class << self
    def send(email)
      @client = loadSESClientCreation
      send_email(email)
    end

    protected
    # Load AWS SES Client
    def loadSESClientCreation
      Aws::SES::Client.new( access_key_id: ENV['h_aws_access_key_id'],
                            secret_access_key: ENV['h_aws_secret_access_key'],
                            region: 'us-east-1')
    end

    def send_email(email)
      if Rails.env.eql?("development")
        log_fake_mail(email)
      else
        send_real_mail(email)
      end
    end

    def log_fake_mail
      puts "------- IN DEVELOPMENT MODE. Sending an email to #{email}. -------"
    end

    def send_real_mail(email)
      mwEmail = "harveyh1@tcnj.edu"

      #Used to send email
      @client.send_email(
        source: mwEmail,
        destination: {
          to_addresses: [email]
        },
        message: message_attributes,
        reply_to_addresses: ["musicianswanted@do-not-reply.com"],
        return_path: mwEmail
      )
    end

    def message_attributes
      {
        subject: {
          data: "Welcome to Musicians Wanted!",
          charset: "UTF-8",
        },
        body: body_attributes
      }
    end

    def body_attributes
      {
        text: {
          data: "Musicians Wanted",
          charset: "UTF-8",
        },
        html: {
          data: "Thanks for signing up for Musicians Wanted!<br><br>We hope you enjoy the application!<br><br>Thanks,<br>The Musicians Wanted Team",
          charset: "UTF-8",
        },
      }
    end
  end
end
