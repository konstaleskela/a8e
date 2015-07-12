Sidekiq::Logging.logger.level = Logger::DEBUG

class MassMailWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(random, mass_mail_id, attendee_id)
    puts "----------------------------"
    puts "----------------------------"
    puts "#{random} Starting mail work"
    mass_mail = MassMail.find(mass_mail_id)
    attendee = Attendee.find(attendee_id)
    if SentMassMail.where(:mass_mail => mass_mail, :attendee => attendee).take.blank?
      begin
        # HACK to get replace tokens in...
        #extra_info_url = Rails.application.routes.url_helpers.extra_info_form_url(:token => attendee.token)
        #above fails with: Missing host to link to! Please provide the :host parameter, set default_url_options[:host], or set :only_path to true
        extra_info_url = "http://a8e.fi/p/#{attendee.token}"
        replace_tokens = {
          "||EXTRA_INFO_FORM_LINK||" => "<a href='#{extra_info_url}'>Siirry antamaan lisätietoja</a>"
        }
        recipient_address = attendee.email
        if EmailValidator.valid?(recipient_address)
          mass_mail.send_to(recipient_address,replace_tokens)
          puts "Success! Mail sent to: #{recipient_address}"
        else
          puts "ERROR: didn't bother to send to invalid email #{recipient_address}"
        end
      rescue
        puts "Failed mail sending with error: #{$!}"
        puts "TO: #{recipient_address}"
      end
      attendee.sent_mass_mails << SentMassMail.new(:mass_mail => mass_mail)
    else
      puts "ALREADY SENT! Skipping..."
    end
    puts "----------------------------"
    puts "----------------------------"
    Attendee.mass_mail_to_next(mass_mail)
  end
end
