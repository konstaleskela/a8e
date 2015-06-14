require 'csv'
class Attendee < ActiveRecord::Base
  belongs_to :event
  belongs_to :school

  after_save :create_reference_number

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |attendee|
        csv << attendee.attributes.values_at(*column_names)
      end
    end
  end

  private

  def create_reference_number
    self.update_column(:reference_number, ReferenceNumber.new(self.id+1000).to_s)
  end

end
