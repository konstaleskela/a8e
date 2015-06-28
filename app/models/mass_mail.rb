class MassMail < ActiveRecord::Base
  has_many :sent_mass_mails

  def send_to(recipient)
    email = EventMailer.generic_mail(recipient,subject,content)
    email.deliver
  end
end
