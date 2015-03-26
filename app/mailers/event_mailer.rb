class EventMailer < ActionMailer::Base
  default from: "info@a8e.fi"

  def agt2016(name, recipient, school)
    @name = name
    mail(to: recipient, subject: 'Abit Goes To Tallinn Varausmaksu')
  end
end
