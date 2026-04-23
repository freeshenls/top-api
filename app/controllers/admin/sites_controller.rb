class Admin::SitesController < Admin::BaseController
  before_action :set_site, only: [:edit, :update, :destroy]

  def index
    @sites = Site.includes(:category).order('category.position ASC, site.position ASC')
    
    if params[:q].present?
      @sites = @sites.where("site.name ILIKE :q OR site.description ILIKE :q", q: "%#{params[:q]}%")
    end

    @pagy, @sites = pagy(:offset, @sites, items: 30)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(site_params)
    if @site.save
      redirect_to admin_sites_path, notice: '站点创建成功'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @site.update(site_params)
      redirect_to admin_sites_path, notice: '站点更新成功'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @site.destroy
    redirect_to admin_sites_path, notice: '站点已删除'
  end

  private

  def set_site
    @site = Site.find(params[:id])
  end

  def site_params
    params.require(:site).permit(:name, :url, :description, :icon_url, :category_id, :position, :active)
  end
end
