Sidekiq::Logging.logger.level = Logger::DEBUG

class MassMailWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(random, mass_mail_id, attendee_id, skip=false)
    puts "--------------------------------------------------------"
    puts "--------------------------------------------------------"
    puts "#{random} Starting mail work"
    mass_mail = MassMail.find(mass_mail_id)
    attendee = Attendee.find(attendee_id)
    aid = nil
    aid = attendee.id if attendee
    if SentMassMail.where(:mass_mail => mass_mail, :attendee_id => aid).take.blank?
      unless skip
        begin
          # HACK to get replace tokens in...
          #extra_info_url = Rails.application.routes.url_helpers.extra_info_form_url(:token => attendee.token)
          #above fails with: Missing host to link to! Please provide the :host parameter, set default_url_options[:host], or set :only_path to true
          extra_info_url = "http://a8e.fi/p/#{attendee.token}"
          replace_tokens = {
            "||EXTRA_INFO_FORM_LINK||" => "<a href='#{extra_info_url}'>#{extra_info_url}</a>"
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
      else
        puts "|---------------------------"
        puts "SKIPPED"
        puts "|---------------------------"
      end
      attendee.sent_mass_mails << SentMassMail.new(:mass_mail => mass_mail)
    else
      puts "ALREADY SENT! Skipping..."
    end
    puts "\n"
    puts "\n"
    puts "\n"
    puts "\n"
    Attendee.mass_mail_to_next(mass_mail)
  end
end
