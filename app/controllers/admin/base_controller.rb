class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :ensure_admin!

  private

  def ensure_admin!
    unless current_user.is_admin?
      redirect_to root_path, alert: "您没有权限访问管理员后台"
    end
  end
end
