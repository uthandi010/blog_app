class ApplicationController < ActionController::API
  include Clearance::Controller
  before_action :current_user

  def current_user
    token = request.headers['Authorization'].to_s.split(' ').last
    return nil if token.blank?

    @_current_user ||= User.find_by(remember_token: token)
  end
end