class MeetingController < ApplicationController

  def channel

    @meeting = Meeting.where(:id => params[:channel]).first    
    @session_id = @meeting.tokbox_session_id if @meeting
    #@token = OTSDK.generate_token(@session_id, {:expire_time => Time.now.to_i+(1 * 24 * 60 * 60)}) if @meeting
    @token = OTSDK.generate_token(@session_id, {:expire_time => Time.now.to_i+(1 * 1 * 60 * 60)}) if @meeting
    @channel = params[:channel]
  end

end
