module Admin
  class CarouselItemsController < BaseController
    before_action :set_carousel_item, only: [:edit, :update, :destroy]

    def index
      @carousel_items = CarouselItem.order(position: :asc)
      
      if params[:q].present?
        @carousel_items = @carousel_items.where("carousel_item.title ILIKE :q OR carousel_item.description ILIKE :q", q: "%#{params[:q]}%")
      end

      @pagy, @carousel_items = pagy(:offset, @carousel_items, items: 15)

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def new
      @carousel_item = CarouselItem.new(active: true, position: 0)
    end

    def create
      @carousel_item = CarouselItem.new(carousel_item_params)
      if @carousel_item.save
        redirect_to admin_carousel_items_path, notice: '轮播图创建成功'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @carousel_item.update(carousel_item_params)
        redirect_to admin_carousel_items_path, notice: '轮播图更新成功'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @carousel_item.destroy
      redirect_to admin_carousel_items_path, notice: '轮播图已删除'
    end

    private

    def set_carousel_item
      @carousel_item = CarouselItem.find(params[:id])
    end

    def carousel_item_params
      params.require(:carousel_item).permit(:title, :description, :image, :link, :position, :active)
    end
  end
end
