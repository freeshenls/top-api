class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.order(position: :asc)
    
    if params[:q].present?
      @categories = @categories.where("category.name ILIKE :q", q: "%#{params[:q]}%")
    end

    @pagy, @categories = pagy(:offset, @categories, items: 30)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: '分类创建成功'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: '分类更新成功'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: '分类已删除'
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :icon, :position, :active, :parent_id)
  end
end
