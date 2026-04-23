class HomeController < ApplicationController
  def index
    # 获取前 4 名 VIP 会员展示在首页 (增加 eager loading)
    @featured_members = Sys::User.where(is_vip: true).limit(4)
    
    # 获取轮播图
    @carousel_items = CarouselItem.where(active: true).order(position: :asc)
    
    # 侧边栏分类 (增加 eager loading 解决子分类显示)
    @all_categories = Category.roots.includes(:children).order(position: :asc)
    
    # 主内容分类
    category_scope = Category.roots.includes(children: :sites).order(position: :asc)
    @pagy, @categories = pagy(category_scope, page: params[:page], items: 2)
    
    # 活动列表 (仅限最近 5 条)
    @upcoming_activities = Activity.upcoming.limit(5)
    
    # 动态列表 (仅限最新 5 条)
    @latest_posts = Post.order(published_at: :desc).limit(5)

    respond_to do |format|
      format.html
      format.turbo_stream
    end

    # 兜底 Mock 数据
    if @featured_members.empty?
      @featured_members = [
        Sys::User.new(id: 1, username: '程城', bio: '建材行业企业主', skills: 'AI 自动获客', member_code: '056'),
        Sys::User.new(id: 2, username: '张经理', bio: '电商资深运营', skills: 'AI 店商提效', member_code: '012')
      ]
    end
  end

  def user_card
    render layout: false
  end
end
