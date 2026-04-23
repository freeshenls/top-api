# frozen_string_literal: true

class Sys::SessionsController < Devise::SessionsController
  layout -> { false if request.headers["Turbo-Frame"].present? }

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    if request.format.html? && !request.xhr? && request.headers["Turbo-Frame"].nil?
      redirect_to root_path(open_auth: true)
    else
      super
    end
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate(auth_options)
    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      redirect_to after_sign_in_path_for(resource), status: :see_other
    else
      # 登录失败，不跳转，直接渲染 new 并返回 422
      self.resource = build_resource(sign_in_params)
      clean_up_passwords(resource)
      flash.now[:alert] = "账号或密码错误"
      render :new, status: :unprocessable_entity
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
