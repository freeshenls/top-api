# frozen_string_literal: true

module Sys
  class User < ApplicationRecord
    def self.model_name
      ActiveModel::Name.new(self, nil, "User")
    end

    self.table_name = "sys_user"
    attr_accessor :login, :lng, :lat

    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable,
           authentication_keys: [:login]

    enum :vip_type, { monthly: "monthly", yearly: "yearly", lifetime: "lifetime" }, prefix: true


    validates :username, presence: true, uniqueness: { case_sensitive: false }
    
    before_validation :set_default_nickname, on: :create

    # 保存前将地图点选的经纬度转为 PostGIS Point
    before_validation :set_coords_from_params, if: -> { lng.present? && lat.present? }

    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if (login = conditions.delete(:login))
        where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
      else
        where(conditions.to_h).first
      end
    end

    private

    def set_coords_from_params
      # 加上微小偏移让地图点更自然
      self.coords = "POINT(#{lng.to_f + (rand-0.5)*0.0005} #{lat.to_f + (rand-0.5)*0.0005})"
    end

    def set_default_nickname
      self.nickname ||= username if username.present?
    end
  end
end
