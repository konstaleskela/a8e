class SentMassMail < ActiveRecord::Base
  belongs_to :mass_mail
  belongs_to :attendee
end
