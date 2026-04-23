class AddSkillsAndExpectationsToSysUser < ActiveRecord::Migration[8.1]
  def change
    add_column :sys_user, :skills, :text
    add_column :sys_user, :expectations, :text
  end
end
