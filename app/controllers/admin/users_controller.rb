class Admin::UsersController < Admin::BaseController
  def index
    @users = Sys::User.order(created_at: :desc)
    
    if params[:q].present?
      @users = @users.where("sys_user.username ILIKE :q OR sys_user.email ILIKE :q", q: "%#{params[:q]}%")
    end

    @pagy, @users = pagy(:offset, @users, items: 20)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def toggle_vip
    @user = Sys::User.find(params[:id])
    if @user.is_vip && params[:vip_type].blank?
      @user.update(is_vip: false, vip_type: nil)
    else
      @user.update(is_vip: true, vip_type: params[:vip_type] || :monthly)
    end
    redirect_to admin_users_path, notice: "用户 #{@user.username} 的会员状态已更新", status: :see_other
  end

  def update
    @user = Sys::User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "用户资料已更新"
    else
      redirect_to admin_users_path, alert: "更新失败"
    end
  end

  private

  def user_params
    params.require(:sys_user).permit(:is_vip, :vip_type, :member_code, :bio, :skills, :expectations)
  end
end
