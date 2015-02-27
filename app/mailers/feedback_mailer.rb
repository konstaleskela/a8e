class FeedbackMailer < ActionMailer::Base
  default from: "website@a8e.fi"

  def simple(contact, message)
    @contact = contact
    @message = message
    mail(to: 'nileskel@gmail.com', subject: 'Yhteydenotto nettisivulta')
  end
end
