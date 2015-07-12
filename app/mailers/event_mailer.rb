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

  def agt2016_attendance_payment_late(attendee)
    @recipient = attendee.email
    @reference_number = attendee.reference_number
    mail(to: @recipient, subject: 'Abi Goes Tallinn varausmaksu myöhässä')
  end

  def agt2016_attendance_payment_late2(attendee)
    @name = attendee.name
    @recipient = attendee.email
    @reference_number = attendee.reference_number
    mail(to: @recipient, subject: 'Abi Goes Tallinn varausmaksu myöhässä')
  end

  def generic_mail(to,subject,content)
    mail(to: to, subject: subject) do |format|
      format.html {
        @html_content = content
        # turn two linebreaks to paragraphs
        @html_content = content.gsub /\r\n\r\n/, ' </p><p>'
        # turn one linebreak to br
        @html_content = @html_content.gsub /\r\n/, '<br /> '
        render :generic_mail
      }
      format.text {
        @text_content = content
        # turn links into text (linktext: href)
        @text_content = content.gsub /<a\s*href='(?=[^"]*)([^"]*)'>([^<]*)<\/a>/, '\2: \1'
        render :generic_mail
      }
    end
  end

end
