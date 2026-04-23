class AddAiPointsToSysUser < ActiveRecord::Migration[8.1]
  def change
    add_column :sys_user, :ai_points, :integer, default: 0
  end
end
