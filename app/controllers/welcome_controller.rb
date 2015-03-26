class WelcomeController < ApplicationController

  def index
    # for abit-goes-to-tallinn form
    @attendee = Attendee.new
  end

  def conditions
    render :conditions, :layout => false
  end

  def under_construction
  end

end
