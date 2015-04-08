class AttendeesController < ApplicationController
  before_filter :authenticate, :except => [:create]

  def index
    @list_confirmed = params.has_key?("confirmed")

    if @list_confirmed
      @attendees = Attendee.where(:confirmed => true)
    else
      @attendees = Attendee.where(:confirmed => false)
    end

    @attendees = @attendees.order('created_at DESC')
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
        if @attendee.save
          FormSenderCache.create({:address => request.remote_ip, :expires => 1.minute.from_now})
          email = EventMailer.agt2016_attendance_created(@attendee)
          email.deliver
          format.html { redirect_to @attendee, notice: 'Attendee was successfully created.' }
          format.json { render action: 'show', status: :created, location: @attendee }
        else
          format.html { render action: 'new' }
          format.json { render json: @attendee.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def confirm
    attendee = Attendee.find(params[:id])
    attendee.update_column(:confirmed, true)
    email = EventMailer.agt2016_attendance_confirmed(attendee)
    email.deliver
    redirect_to attendees_path
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendee_params
      params.require(:attendee).permit(:name, :phone, :email, :event_id, :school_id)
    end
end
