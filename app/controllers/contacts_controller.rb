class ContactsController < ApplicationController
  
  before_filter :authenticate_user!

  def index
    @users = User.all.where.not(id: current_user.id)
  end

end
