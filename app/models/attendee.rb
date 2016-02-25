require 'csv'
class Attendee < ActiveRecord::Base
  belongs_to :event
  belongs_to :school
  has_many :sent_mass_mails

  after_save :create_reference_number

  scope :confirmed, -> { where(confirmed: true) }
  scope :unconfirmed, -> { where(confirmed: false) }
  scope :confirmed_unanswered, -> { confirmed.where("dob IS NULL") }

  validates :token, :uniqueness => true

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |attendee|
        csv << attendee.attributes.values_at(*column_names)
      end
    end
  end

  def self.mass_mail_to_next(mass_mail)
    # not bulletproof, since one might be missing from the middle for
    # whatever reason, but close enough...
    # next to the last recipient of mass mail or first if none sent.
    last_sent = SentMassMail.where(:mass_mail => mass_mail).last
    recipient_id = nil
    skope = :confirmed #_unanswered
    if last_sent.blank?
      recipient = Attendee.send(skope).order('created_at ASC').take if Attendee.send(skope).first
      recipient_id = recipient.id if recipient
    else
      recipient = last_sent.attendee.next(skope) if last_sent.attendee.next(skope)
      recipient_id = recipient.id if recipient
    end
    # only send during 9 - 24 every minute to even out the load to sending and server requests
    hour = Time.zone.now.hour
    time_to_next = (hour <= 23 && hour >= 9) ? 1.minutes : 9.hours + 10.minutes
    # see if in recipient list
    skip = false
    if recipient && mass_mail.recipients && !mm.recipients.strip.blank?
      recipients = mass_mail.recipients.split("\n")
      recipients.map!{|e| e.strip}
      unless recipients.include?(recipient.email)
        skip = true
        time_to_next = 1.seconds
      end
      #if recipients.each do
      #recipient_id
    end
    # perform async in five seconds
    if recipient && recipient_id
      puts "BEGIN SENDING TO #{recipient.email}"
      MassMailWorker.perform_in(time_to_next, rand(1000), mass_mail.id, recipient_id, skip)
    else
      return false
    end
  end

  def generate_token
    token = [*('a'..'z'),*('0'..'9')].shuffle[0,18].join
    self.update(:token => token)
  end

  def next(skope = :confirmed)
    Attendee.send(skope).where("created_at >= ? AND id != ?", created_at, id).order("created_at ASC").first
  end

  def previous(skope = :confirmed)
    Attendee.send(skope).where("created_at <= ? AND id != ?", created_at, id).order("created_at DESC").first
  end

  private

  def create_reference_number
    self.update_column(:reference_number, ReferenceNumber.new(self.id+1000).to_s)
  end

end
