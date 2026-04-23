# frozen_string_literal: true

class DeviseCreateSysUser < ActiveRecord::Migration[8.1]
  def change
    create_table :sys_user do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.string :username
      t.string :nickname
      t.string :province
      t.string :city
      t.string :district
      t.string :wechat_id
      t.boolean :wechat_public, default: false

      t.boolean :is_vip, default: false
      t.datetime :vip_expired_at

      t.st_point :coords, geographic: true, srid: 4326

      t.timestamps null: false
    end

    add_index :sys_user, :email,                unique: true
    add_index :sys_user, :reset_password_token, unique: true
    # add_index :sys_user, :confirmation_token,   unique: true
    # add_index :sys_user, :unlock_token,         unique: true

    add_index :sys_user, :username, unique: true
    add_index :sys_user, :coords, using: :gist
  end
end
