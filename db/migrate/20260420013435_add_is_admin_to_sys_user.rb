class AddIsAdminToSysUser < ActiveRecord::Migration[8.1]
  def change
    add_column :sys_user, :is_admin, :boolean, default: false
  end
end
