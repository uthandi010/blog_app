class ApplicationController < ActionController::API
  include Clearance::Controller
  before_action :current_user 
  

  def current_user  
    @_current_user ||= User.find_by(remember_token: request.headers['Authorization'].split(' ').last)
  end
end
