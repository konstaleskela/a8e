class MassMail < ActiveRecord::Base
  has_many :sent_mass_mails

  def send_to(recipient,replace_tokens=nil)
    content_to_send = content
    # HACK to get replace tokens in...
    replace_tokens.each { |k, v| content_to_send.sub!(k, v) } if replace_tokens
    email = EventMailer.generic_mail(recipient,subject,content_to_send)
    email.deliver
  end
end
