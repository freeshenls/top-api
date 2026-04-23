class MembersController < ApplicationController
  def show
    @member = Sys::User.find_by(id: params[:id])
    redirect_to root_path, alert: "找不到该会员信息" unless @member

    # 中心点坐标
    center_lat = @member.coords&.y || 30.0
    center_lng = @member.coords&.x || 110.0

    # 会员探索雷达数据 (500名随机用户)
    @radar_members = Sys::User.where.not(id: @member.id).order("RANDOM()").limit(500).map do |u|
      lat = u.coords&.y || (30.0 + rand(-1.0..1.0)).round(4)
      lng = u.coords&.x || (110.0 + rand(-1.0..1.0)).round(4)
      
      # 简单的距离计算 (Haversine)
      dist = calculate_distance(center_lat, center_lng, lat, lng)

      {
        id: u.id,
        username: u.username,
        bio: u.bio.presence || "AI 探索者",
        lat: lat,
        lng: lng,
        distance: dist
      }
    end
  end

  def card
    @member = Sys::User.find(params[:id])
    render layout: false
  end

  private

  def calculate_distance(lat1, lon1, lat2, lon2)
    return 0 if lat1 == lat2 && lon1 == lon2
    r = 6371 # 地球半径 km
    d_lat = (lat2 - lat1) * Math::PI / 180
    d_lon = (lon2 - lon1) * Math::PI / 180
    a = Math.sin(d_lat / 2)**2 + Math.cos(lat1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) * Math.sin(d_lon / 2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    (r * c).round(1)
  end
end
