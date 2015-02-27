class FeedbackController < ApplicationController

  def send_message
    contact = params[:contact]
    message = params[:message]
    if !contact.blank? && !message.blank?
      FeedbackMailer.simple(contact, message).deliver
    end
    redirect_to '/proto?sent=true'
  end

end
