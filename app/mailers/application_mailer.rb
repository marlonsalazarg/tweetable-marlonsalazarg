class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_SENDER", "Tweetable <no-reply@localhost>")
  layout "mailer"
end
