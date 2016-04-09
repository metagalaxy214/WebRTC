  var pusher = new Pusher("a60be26a89bce85a752e");  
  
  var core_channel = pusher.subscribe("core_channel");

  core_channel.bind("event-join", function(data) {
    console.log(data);
    if (data.channel === $('#channel').val()) {
      window.location.href = '/meeting-channel/' + data.channel;
    }
  });

  core_channel.bind("event-invite", function(data) {
    var r;
    console.log("event-invite:");
    console.log(data);
    if (data.to_email === $('#my_email').val()) {
      console.log('same:');
      console.log($('#my_email').val());
      r = $('tr.contact-row[data-contact-email="' + data.from_email + '"]');
      r.attr('data-channel', data.channel);
      r.addClass('calling');

      if(r.hasClass('row-selected')){
        $('#invite_meeting').addClass('disabled');  
        $('#accept_meeting').removeClass('disabled');
      }
      
    }
  });

  core_channel.bind("event-end", function(data) {
    var r;
    console.log("event-end:");
    console.log(data);
    r = $('tr.contact-row[data-channel="' + data.channel + '"]');
    r.removeAttr('data-channel');
    r.removeClass('calling');
    if($('#channel').val() == data.channel ) {  
      window.location.href = '/';
    }
  });
  core_channel.bind("new-message", function(data) {
    console.log(data);
    if(data.communicationType == 'signin'){
      r = $('tr.contact-row[data-contact-email="' + data.sender + '"]');
      
      r.find('.online-column').removeClass('contact-offline').addClass('contact-online');
    }
    if(data.communicationType == 'signout'){
      r = $('tr.contact-row[data-contact-email="' + data.sender + '"]');
      
      r.find('.online-column').removeClass('contact-online').addClass('contact-offline');
    }
    if(data.communicationType == 'addcontact'){
      if($('#all_contacts').length > 0){
        window.location.href = '/';
      }
    }
  });





