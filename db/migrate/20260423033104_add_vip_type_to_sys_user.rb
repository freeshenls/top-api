class AddVipTypeToSysUser < ActiveRecord::Migration[8.1]
  def change
    add_column :sys_user, :vip_type, :string
  end
end
