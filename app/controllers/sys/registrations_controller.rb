# frozen_string_literal: true

class Sys::RegistrationsController < Devise::RegistrationsController
  layout -> { false if request.headers["Turbo-Frame"].present? }
  prepend_before_action :check_captcha, only: [:create]
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    if request.format.html? && !request.xhr? && request.headers["Turbo-Frame"].nil?
      redirect_to root_path(open_auth: true)
    else
      super
    end
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        redirect_to after_sign_up_path_for(resource), status: :see_other
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        redirect_to after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      # Force 422 status for Turbo
      render :new, status: :unprocessable_entity
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :nickname, :email, :password, :lng, :lat])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :nickname, :lng, :lat])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def check_captcha
    unless verify_rucaptcha?
      self.resource = build_resource(sign_up_params)
      resource.validate # 触发验证以保持表单数据
      respond_with_navigational(resource) { render :new, status: :unprocessable_entity }
    end
  end

  # 注册成功后的跳转路径
  def after_sign_up_path_for(resource)
    root_path
  end
end
