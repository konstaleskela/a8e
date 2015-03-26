class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:show, :edit, :update, :destroy]

  # GET /attendees
  # GET /attendees.json
  def index
    @attendees = Attendee.all
  end

  # GET /attendees/1
  # GET /attendees/1.json
  def show
  end

  # GET /attendees/new
  def new
    @attendee = Attendee.new
  end

  # GET /attendees/1/edit
  def edit
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

  # PATCH/PUT /attendees/1
  # PATCH/PUT /attendees/1.json
  def update
    respond_to do |format|
      if @attendee.update(attendee_params)
        format.html { redirect_to @attendee, notice: 'Attendee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @attendee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendees/1
  # DELETE /attendees/1.json
  def destroy
    @attendee.destroy
    respond_to do |format|
      format.html { redirect_to attendees_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendee
      @attendee = Attendee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendee_params
      params.require(:attendee).permit(:name, :phone, :email, :event_id, :school_id)
    end
end
