class Api::V1::MeetingController < ApplicationController
  require 'json'
  respond_to :json

  def start_session
    # 2.2 Version
    tokbox_session = OTSDK.create_session
    tokbox_session_id = tokbox_session.session_id
    # tokbox_token = tokbox_session.generate_token
    # :expire_time => Time.now.to_i+(7 * 24 * 60 * 60) # in one week
    # :expire_time => Time.now.to_i+(1 * 60 * 60) # in 1 day


    # tokbox_token = tokbox_session.generate_token({
    #     :expire_time => Time.now.to_i+(1 * 1 * 60 * 60)
    #   })
    tokbox_token = "TTT"

    #tokbox_session = OTSDK.createSession(request.remote_ip, {:media_mode => :relayed})
    # tokbox_session = OTSDK.createSession(request.remote_ip, {OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled"})
    # tokbox_session_id = tokbox_session.session_id
    # tokbox_token = tokbox_session.generateToken
    
    # tokbox_session_id = "1_MX40NDcxNDAwMn5-TW9uIEFwciAwNyAwNjowMDo0MiBQRFQgMjAxNH4wLjg0NjA3MTJ-fg"
    # tokbox_token = "T1==cGFydG5lcl9pZD00NDcxNDAwMiZzZGtfdmVyc2lvbj10YnJ1YnktdGJyYi12MC45MS4yMDExLTAyLTE3JnNpZz1lMjQ3ZWY0MjYzYzFlY2U1NjMxN2ZiNjgwZDg5ZWU3NWI5NTliOWRmOnJvbGU9cHVibGlzaGVyJnNlc3Npb25faWQ9MV9NWDQwTkRjeE5EQXdNbjUtVFc5dUlFRndjaUF3TnlBd05qb3dNRG8wTWlCUVJGUWdNakF4Tkg0d0xqZzBOakEzTVRKLWZnJmNyZWF0ZV90aW1lPTEzOTY4NzU2NDMmbm9uY2U9MC44MDA5MDEyMjgyOTgzMTExJmV4cGlyZV90aW1lPTEzOTY5NjIwNDMmY29ubmVjdGlvbl9kYXRhPQ=="

    user = current_user

    to_user = User.find_by_email(params[:email])

    @session_data = {
      tokbox_session_id: tokbox_session_id,
      tokbox_token: tokbox_token,
      pusher_channel: "private-meeting-#{user.updated_at.to_i}",
      user_id: user.id      
    }
    @meeting = Meeting.new(@session_data)
    
    if @meeting.save
      obj_data = {        
        :tokbox_session_id => @meeting.tokbox_session_id, 
        :tokbox_token      => @meeting.tokbox_token,
        :pusher_channel    => @meeting.pusher_channel,
        :channel       => @meeting.id
      }
      Pusher['core_channel'].trigger('event-invite', {              
          from_email: user.email,
          to_email: to_user.email,              
          # tokbox_session_id: @tutor_session.tokbox_session_id,
          # tokbox_token: @tutor_session.tokbox_token,
          # pusher_channel: @tutor_session.pusher_channel,
          channel: @meeting.id.to_s
        })
      @responseObject = {
        status: true,
        errors: [],
        code: API_CODE_ERRORS['Services']['Global']['success'],
        data: obj_data,
        timestamp: (Date.new).to_time.to_i.abs
      }
    else
      @responseObject = {
        status: false,
        errors: [],
        code: API_CODE_ERRORS['Services']['Global']['api_server_not_ready'],
        objectData: []
      }
    end

    # respond_to do |format|
    #   #format.js { render json: @responseObject.to_json }
    #   format.json { render json: @responseObject.to_json }      
    # end
    render :json => {response: @responseObject}, :formats =>[:json]

  end

  def join_session

    user = current_user

    channel = params[:channel]
    @meeting = Meeting.find_by_id(channel)

    if @meeting
    
      @responseObject = {
          status: true,
          errors: [],
          code: API_CODE_ERRORS['Services']['Global']['success'],
          objectData: []
        }
      Pusher['core_channel'].trigger('event-join', {              
          from_email: user.email,
          # tokbox_session_id: @tutor_session.tokbox_session_id,
          # tokbox_token: @tutor_session.tokbox_token,
          # pusher_channel: @tutor_session.pusher_channel,
          channel: @meeting.id.to_s
        })
    else
      @responseObject = {
        status: false,
        errors: [],
        code: API_CODE_ERRORS['Services']['Global']['api_server_not_ready'],
        objectData: []
      }
    end

    render :json => {response: @responseObject}, :formats =>[:json]
  end
  
  def end_session

    user = current_user
    channel = params[:channel]
    
    
    @meeting = Meeting.find_by_id(channel)
    @meeting.update_attribute(:is_expired, true)
    
    @responseObject = {
        status: true,
        errors: [],
        code: API_CODE_ERRORS['Services']['Global']['success'],
        objectData: []
      }
    Pusher['core_channel'].trigger('event-end', {
      from: user.email,
      pusher_channel: @meeting.pusher_channel,
      channel: @meeting.id.to_s
    })
 
    render :json => {response: @responseObject}, :formats =>[:json]

  end

  

end
