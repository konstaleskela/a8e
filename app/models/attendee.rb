class Attendee < ActiveRecord::Base
  belongs_to :event
  belongs_to :school

  after_save :create_reference_number

  private

  def create_reference_number
    self.update_column(:reference_number, ReferenceNumber.new(self.id+1000).to_s)
  end

end
