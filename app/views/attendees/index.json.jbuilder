json.array!(@attendees) do |attendee|
  json.extract! attendee, :id, :name, :phone, :email, :event_id, :school_id
  json.url attendee_url(attendee, format: :json)
end
