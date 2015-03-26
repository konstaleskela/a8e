class AttendeesController < ApplicationController

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
        @attendee = Attendee.new(attendee_params)
        if @attendee.save
          FormSenderCache.create({:address => request.remote_ip, :expires => 1.minute.from_now})
          EventMailer.agt2016(@attendee.name, @attendee.email, @attendee.school).deliver
          format.html { redirect_to @attendee, notice: 'Attendee was successfully created.' }
          format.json { render action: 'show', status: :created, location: @attendee }
        else
          format.html { render action: 'new' }
          format.json { render json: @attendee.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendee_params
      params.require(:attendee).permit(:name, :phone, :email, :event_id, :school_id)
    end
end
