var blink;

$(document).ready(function() {

  setInterval((function() {
    blink();
  }), 2000);

  $("#cancel_calling").on("click", function(e) {
    var channel;
    
    channel = $('#channel').val();
    if(channel.length > 0){
      $.ajax({
        type: "GET",
        url: "/api/v1/meeting-end/"+channel,      
        success: function(data) {          
          $('#calling_modal').modal('hide');
          return false;
        },
        error: function(data) {
          $('#calling_modal').modal('hide');
          return false;
        }
      });
    }
  });
  $("#btn_call").on("click", function(e) {
    var sel_email, sel_name;
    e.preventDefault();
    
    sel_email = $('.row-selected').attr('data-contact-email');
    sel_name = $('.row-selected').attr('data-contact-name');
    if (typeof sel_email === "undefined") {
      alert('Please select a contact');
      return false;
    }
    $('#calling_modal .modal-body').html('Waiting for ' + sel_name);
    $('#calling_modal').modal('show');    

    $.ajax({
      type: "POST",
      url: "/api/v1/meeting-start",    
      data: {
          email: sel_email
        },      
      success: function(data) {
        console.log('Start Meeting:', data);
        var rep = data.response;

        if(rep.status){
          $('#channel').val(rep.data.channel);
        }else{
          $('#calling_modal').modal('hide');
          alet('Sorry, pls try again later');
        }
        
      },
      error: function(data) {
        $('#calling_modal').modal('hide');
        alet('Sorry, network error. Pls try again later');
        return false;
      }
    });
    return false;
  });
  $("#btn_accept").on("click", function(e) {
    var  channel;
    
    channel = $('.row-selected').attr('data-channel');
    if (channel.length > 0) {
      $('#joining_modal').modal('show');
      $.ajax({
        type: "GET",
        url: "/api/v1/meeting-join/"+channel,        
        success: function(data) {
          var rep;
          rep = data.response;
          console.log(rep);
          $('#joining_modal').modal('hide');
          window.location.href = '/meeting-channel/' + channel;
          return false;
        },
        error: function(data) {
          $('#joining_modal').modal('hide');
          return false;
        }
      });
    }
    return false;
  });
  $('#btn_new_contact').on('click', function(e){
    $('#new_contact_modal').modal('show');
  });

  $('#send_contact').on('click', function(e){
    
    auth_token = $('#auth_token').val();
    new_email = $('#new_contact_email').val();
    if(new_email.length > 0 && IsEmail(new_email)> 0){
      $.ajax({
        type: "POST",
        url: "/api/v1/addContact",
        data: {
          authentication_token: auth_token,
          email: new_email
        },
        success: function(data) {
          $('#new_contact_modal').modal('hide');
          $('#new_contact_email').val('');
          window.location.href = '/';
          
        },
        error: function(data) {
          $('#joining_modal').modal('hide');
          return false;
        }
      });
    }else{
      $('#new_contact_email').focus();
    }
  });

});

$(document).on("click", "#all_contacts tr", function(e) {
  $("#all_contacts tr").removeClass("row-selected");
  $(this).addClass("row-selected");  
  $('#btn_call').removeClass('disabled');
  if($(this).hasClass('calling')){
    $('#btn_accept').removeClass('disabled');
  }else{
    $('#btn_accept').addClass('disabled');
  }
});

blink = function() {
  $(".calling").fadeTo(400, 0.1).fadeTo(400, 1);
};
function IsEmail(email) {
  var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  return regex.test(email);
}