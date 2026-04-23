class Admin::DashboardController < Admin::BaseController
  def index
    @stats = {
      total_users: Sys::User.count,
      vip_users: Sys::User.where(is_vip: true).count,
      new_users_today: Sys::User.where('created_at >= ?', Time.zone.now.beginning_of_day).count
    }
  end
end
