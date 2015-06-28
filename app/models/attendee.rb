require 'csv'
class Attendee < ActiveRecord::Base
  belongs_to :event
  belongs_to :school
  has_many :sent_mass_mails

  after_save :create_reference_number

  scope :confirmed, -> { where(confirmed: true) }
  scope :unconfirmed, -> { where(confirmed: false) }

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
    skope = :unconfirmed
    if last_sent.blank?
      recipient_id = Attendee.send(skope).first.id if Attendee.send(skope).first
    else
      recipient_id = last_sent.attendee.next(skope).id if last_sent.attendee.next(skope)
    end
    # perform async in five seconds
    if recipient_id
      MassMailWorker.perform_in(5.seconds, rand(1000), mass_mail.id, recipient_id)
    else
      return false
    end
  end

  def next(skope = :confirmed)
    self.class.send(skope).where("created_at >= ? AND id != ?", created_at, id).order("created_at ASC").first
  end

  def previous(skope = :confirmed)
    self.class.send(skope).where("created_at <= ? AND id != ?", created_at, id).order("created_at DESC").first
  end

  private

  def create_reference_number
    self.update_column(:reference_number, ReferenceNumber.new(self.id+1000).to_s)
  end

end
