class EventMailer < ActionMailer::Base
  default from: "info@a8e.fi"

  def agt2016_attendance_created(attendee)
    @name = attendee.name
    @school = attendee.school
    @recipient = attendee.email
    @reference_number = attendee.reference_number
    mail(to: @recipient, subject: 'Abi Goes Tallinn varausmaksu')
  end

  def agt2016_attendance_confirmed(attendee)
    @recipient = attendee.email
    mail(to: @recipient, subject: 'Abi Goes Tallinn maksuvahvistus')
  end
end
