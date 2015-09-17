class AttendeesController < ApplicationController
  # extra_info stuff should go through different controller...
  before_filter :authenticate, :except => [:create,:extra_info_form,:extra_info_save,:extra_info_saved,:extra_info_error]

  def index
    @list_confirmed = params.has_key?("confirmed")
    @list_unconfirmed = params.has_key?("unconfirmed")
    @list_confirmed_unanswered = params.has_key?("confirmed_unanswered")
    @unconfirmed_ui = true if @list_unconfirmed

    if @list_confirmed
      @attendees = Attendee.confirmed
    elsif @list_unconfirmed
      @attendees = Attendee.where(:confirmed => true)
    elsif @list_confirmed_unanswered
      @attendees = Attendee.confirmed_unanswered
    else
      return redirect_to attendees_path(:confirmed => true)
    end

    @attendees = @attendees.order('created_at DESC')

    respond_to do |format|
      format.html
      format.csv { render text: @attendees.to_csv }
    end
  end

  def destroy
    Attendee.find(params[:id]).destroy
    redirect_to attendees_path
  end

  def new
    @attendee = Attendee.new
  end

  # POST /attendees
  # POST /attendees.json
  def create
    # check if we are allowed to create
    FormSenderCache.clear_cache
    recent_sender = FormSenderCache.where(:address => request.remote_ip).take

    respond_to do |format|
      if recent_sender
        format.html { render text: 'Virhe' }
        format.json { render json: {:error => 1}, status: :unprocessable_entity  }
      else
        valid_params = attendee_params
        # try to create a new school record (or invalidate id 9999 and use nil instead)
        if valid_params[:school_id] == "9999"
          valid_params[:school_id] = nil
          if params[:other_school] && !params[:other_school].blank?
            new_school = School.find_or_create_by(:name => params[:other_school])
            valid_params[:school_id] = new_school.id
          end
        end
        @attendee = Attendee.new(valid_params)
        @attendee.generate_token
        @attendee.new_price = true
        if @attendee.save
          FormSenderCache.create({:address => request.remote_ip, :expires => 1.minute.from_now})
          # added an option to send confirmation (admin only...)
          if params.has_key?('auto_confirm') && params['auto_confirm'] == "on"
            @attendee.update_column(:confirmed,true)
          end
          if params.has_key?('send_email') && params['send_email'] == "on"
            email = EventMailer.agt2016_attendance_created(@attendee)
            email.deliver
          end
          format.html { redirect_to attendees_path, notice: 'Attendee was successfully created.' }
          format.json { render action: 'show', status: :created, location: @attendee }
        else
          format.html { render action: 'new' }
          format.json { render json: @attendee.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def resend_created_mail
    attendee = Attendee.find(params[:id])
    email = EventMailer.agt2016_attendance_created(attendee)
    email.deliver
    redirect_to attendees_path
  end

  def confirm
    attendee = Attendee.find(params[:id])
    attendee.update_column(:confirmed, true)
    email = EventMailer.agt2016_attendance_confirmed(attendee)
    email.deliver
    redirect_to attendees_path
  end

  def latemail
    attendee = Attendee.find(params[:id])
    attendee.update_column(:late_mails_sent, 1)
    email = EventMailer.agt2016_attendance_payment_late(attendee)
    email.deliver
    redirect_to attendees_path
  end

  def latemail2
    attendee = Attendee.find(params[:id])
    attendee.update_column(:late_mails_sent, 2)
    email = EventMailer.agt2016_attendance_payment_late2(attendee)
    email.deliver
    redirect_to attendees_path
  end

  def mass_mailer
    mm = (params[:selected]) ? MassMail.find(params[:selected]) : nil
    @mm_sent = (mm) ? mm.sent : nil
    @existing_subject = (mm) ? mm.subject : nil
    @existing_content = (mm) ? mm.content : nil
  end

  def mass_mail_create
    if params.has_key?(:mm_id)
      mm = MassMail.find(params[:mm_id])
    else
      if params[:name].blank?
        flash[:notice] = {:text => "Viestin nimi ei voi olla tyhjä", :type => "alert" }
      elsif !MassMail.where(:name => params[:name]).blank?
        flash[:notice] = {:text => "Viesti on jo olemassa!", :type => "alert" }
        return nil
      else
        mm = MassMail.create(:name => params[:name], :subject => params[:subject], :content => params[:content])
      end
    end
    return mm
  end

  def mass_mail_test(mm)
    # HACK to get replace tokens in...
    extra_info_url = "http://google.com"
    replace_tokens = {
      "||EXTRA_INFO_FORM_LINK||" => "<a href='#{extra_info_url}'>#{extra_info_url}</a>"
    }
    mm.send_to(params[:test_recipient],replace_tokens)
    flash[:notice] = {:text => "Esimerkkiviesti lähetettiin onnistuneesti", :type => "info" }
  end

  def mass_mail_all(mm)
    if mm && Attendee.mass_mail_to_next(mm)
      flash[:notice] = {:text => "Massaviestin lähettäminen aloitettiin onnistuneesti", :type => "info" }
      mm.update_column(:sent, true)
    else
      flash[:notice] = {:text => "Lähetys epäonnistui", :type => "alert" }
    end
  end

  def mass_mail_to
    mm = mass_mail_create
    if params[:test_recipient].blank?
      mass_mail_all(mm) if mm
      redirect_to mass_mailer_attendees_path(:selected => mm.id)
    else
      mass_mail_test(mm) if mm
      redirect_to mass_mailer_attendees_path(:selected => mm.id)
    end
  end

  def extra_info_form
    @attendee = Attendee.where(:token => params[:token]).take
    if !@attendee || !@attendee.town.blank?
      render :extra_info_error
    else
      render :extra_info_form
    end
  end

  def extra_info_save
    @attendee = Attendee.where(:token => params[:token]).take
    if !@attendee || !@attendee.town.blank?
      render :extra_info_error
    else
      has_error = false
      ['day','month','year','address','postnumber','town'].each do |k|
        has_error = true if !params.has_key?(k)
        has_error = true if !has_error && params[k].blank?
      end
      if has_error
        render :extra_info_error
      else
        # raw input data has to be fine at this point
        # make sure now errors are raised for wrong data
        year = Integer(params[:year]) rescue nil
        month = Integer(params[:month]) rescue nil
        day = Integer(params[:day]) rescue nil
        dob = nil
        dob = Date.new(year,month,day) rescue nil if year && month && day
        if @attendee.update({:dob => dob,
                          :address => params[:address],
                          :postnumber => params[:postnumber],
                          :town => params[:town]})
          redirect_to :extra_info_saved
        else
          render :extra_info_error
        end
      end
    end
  end

  def extra_info_saved
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendee_params
      params.require(:attendee).permit(:name, :phone, :email, :dob, :address, :postnumber, :town, :event_id, :school_id)
    end
end
