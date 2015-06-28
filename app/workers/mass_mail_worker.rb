class MassMailWorker
  include Sidekiq::Worker

  def perform(random, mass_mail_id, attendee_id)
    puts "#{random} Starting mail work"
    mass_mail = MassMail.find(mass_mail_id)
    attendee = Attendee.find(attendee_id)
    if SentMassMail.where(:mass_mail => mass_mail, :attendee => attendee).take.blank?
      puts "Send mail!"
      #mass_mail.send_to(attendee.email)
      attendee.sent_mass_mails << SentMassMail.new(:mass_mail => mass_mail)
    else
      puts "ALREADY SENT! Skipping..."
    end
    Attendee.mass_mail_to_next(mass_mail)
  end
end
