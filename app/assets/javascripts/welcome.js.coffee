$ ->
  $("#contact-form").submit ->
    form = $(@)
    contactVal = form.find("input[name='contact']").val().trim()
    messageVal = form.find("textarea[name='message']").val().trim()
    if contactVal is "" or messageVal is ""
      alert "Täytäthän molemmat kentät"
      return false
