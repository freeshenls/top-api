class AddBioAndMemberCodeToSysUser < ActiveRecord::Migration[8.1]
  def change
    add_column :sys_user, :bio, :text
    add_column :sys_user, :member_code, :string
  end
end
