
# Pusher.app_id = ENV['PUSHER_APP_ID']
# Pusher.key    = ENV['PUSHER_KEY']
# Pusher.secret = ENV['PUSHER_SECRET']
Pusher.app_id = "93684"
Pusher.key    = "a60be26a89bce85a752e"
Pusher.secret = "95f6ae14f78bcbcbfb14"


Pusher.encrypted = !Rails.env.test?

#if Rails.env.development?
  #PusherFake.configure do |configuration|
    #configuration.app_id = Pusher.app_id
    #configuration.key    = Pusher.key
    #configuration.secret = Pusher.secret
  #end

  ## Set the host and port to the fake web server.
  #Pusher.host = PusherFake.configuration.web_host
  #Pusher.port = PusherFake.configuration.web_port
#end
