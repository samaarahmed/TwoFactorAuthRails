class ApplicationController < ActionController::Base

    before_action :authenticate_user!
# app/controllers/application_controller.rb
private

def after_sign_in_path_for(resource)
  dashboard_path
end


end
