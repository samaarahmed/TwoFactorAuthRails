class Users::SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]
  
    # GET /resource/sign_in
    # def new
    #   super
    # end
  
    # POST /resource/sign_in
    def create
      self.resource = warden.authenticate!(:database_authenticatable, auth_options)
  
      if resource.otp_required_for_login?
        sign_out(resource)
        session[:otp_user_id] = resource.id
        session[:otp_user_id_expires_at] = 30.seconds.after
  
        redirect_to users_sign_in_otp_path
      else
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        respond_with resource, location: after_sign_in_path_for(resource)
      end
    end
  
    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end
  
    # protected
  
    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end