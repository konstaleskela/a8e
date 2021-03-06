$ ->
  modal = $("#abit-goes-to-tallinn-modal")
  formWrapper = modal.find("#form-wrapper")
  thanksWrapper = modal.find("#thanks-wrapper")
  form = formWrapper.find("#new_attendee")
  otherSchool = form.find('.input.other_school')
  submitButton = form.find('.submit-button')
  errorAlert1 = modal.find("#general-error-alert")
  errorAlert2 = modal.find("#check-data-error-alert")

  form.find('#attendee_school_id').on 'change', ->
    otherSchool.hide()
    otherSchool.show() if $(@).val() is "9999"

  $("#new_attendee").on 'ajax:before', ->
    toggleButton(submitButton, false)
    checkData = false
    # check required input
    checkData = true if form.find("#attendee_name").val().trim() is ""
    checkData = true if form.find("#attendee_phone").val().trim() is ""
    checkData = true if form.find("#attendee_email").val().trim() is ""
    checkData = true if form.find("#attendee_email").val().indexOf('@') is -1
    checkData = true if form.find("#attendee_school_id").val().trim() is ""
    checkData = true if not form.find("#conditions-approved")[0].checked
    checkData = true if form.find("#conditions-approved").val() is ""
    checkData = true if otherSchool.find('input').is(':visible') && otherSchool.find('input').val() is ""
    if checkData
      toggleButton(submitButton, true)
      errorAlert1.hide()
      errorAlert2.fadeOut(300).fadeIn(300)
      return false

  $("#new_attendee").on 'ajax:error', (event, data, status, xhr) ->
    toggleButton(submitButton, true)
    errorAlert2.hide()
    errorAlert1.fadeOut(300).fadeIn(300)

  $("#new_attendee").on 'ajax:success', (event, data, status, xhr) ->
    toggleButton(submitButton, true)
    formWrapper.hide()
    thanksWrapper.show()
    resetForm()
    $("html, body").animate
      scrollTop: modal.offset().top - 100
    , 500

  modal.on "closed.fndtn.reveal", ->
    formWrapper.show()
    thanksWrapper.hide()
    resetForm()

  resetForm = ->
    errorAlert1.hide()
    errorAlert2.hide()
    otherSchool.hide()
    form.find("input.string, select").val('')
    form.find("input[type='checkbox']").prop('checked',false)

  toggleButton = (btn,flip) ->
    enable = disable = false
    enable = true if flip is true
    disable = true if flip is false
    if disable
      btn.attr('disabled',true)
      btn.attr('data-enabled-text',btn.val())
      btn.val(btn.data('disabled-text'))
    if enable
      btn.attr('disabled',false)
      btn.val(btn.attr('data-enabled-text'))

  $("#extra-info").on 'submit', ->
    form = $(@)
    error = false
    for iname in ['day','month','year','address','postnumber','town']
      do (iname) ->
        val = form.find("#"+iname+"-input").val()
        error = true unless val?
        error = true if !error and val.trim() is ""

    if error
      $("#check-data-error-alert").fadeOut(300).fadeIn(300)
      return false

  # show extra info
  $(".show-extra-info").on 'click', ->
    id_to_show = $(@).data('id')
    elem_to_show = $("tr#extra_info_for_"+id_to_show)
    if elem_to_show.is(':visible')
    then elem_to_show.hide()
    else elem_to_show.show()

  # add new form for admins
  send_email_cb = $("input[name='send_email']")
  auto_confirm_cb = $("input[name='auto_confirm']")
  $("input[name='auto_confirm']").on 'change', ->
    send_email_cb.prop('checked',false) if auto_confirm_cb.is(':checked')
