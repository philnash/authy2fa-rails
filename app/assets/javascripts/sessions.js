$(document).ready(function() {

  $('#login-form').submit(function(e) {
    e.preventDefault();
    formData = $(e.currentTarget).serialize();
    attemptOneTouchVerification(formData);
  })

  var attemptOneTouchVerification = function(form) {
    $.post( "/sessions", form, function(data) {
      $('#authy-modal').modal({backdrop:'static'},'show')
      if (data.success) {
        $('.auth-ot').fadeIn()
        checkForOneTouch();
      } else {
        $('.auth-token').fadeIn()
      }
    })
  };

  var checkForOneTouch = function() {
    var source = new EventSource("/authy/live_status")
    source.addEventListener("authy_status", function(event) {
      var data = JSON.parse(event.data);
      if (data.status === "approved") {
        source.close();
        window.location.href = "/account";
      } else if (data.status === "denied") {
        showTokenForm();
        triggerSMSToken();
      }
    })
  };

  var showTokenForm = function() {
    $('.auth-ot').fadeOut(function() {
      $('.auth-token').fadeIn('slow')
    })
  };

  var triggerSMSToken = function() {
    $.get("/authy/send_token")
  };
})

