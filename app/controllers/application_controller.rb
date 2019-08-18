class ApplicationController < ActionController::Base
  before_action :deactivate_session

  private

  def deactivate_session
    request.session_options[:skip] = true
  end
end
