module Admin
  class PostsController < BaseController
    before_action :set_post, only: [:edit, :update, :destroy]

    def index
      @posts = Post.order(published_at: :desc)
      
      if params[:q].present?
        @posts = @posts.where("post.title ILIKE :q OR post.content ILIKE :q", q: "%#{params[:q]}%")
      end

      @pagy, @posts = pagy(:offset, @posts, items: 20)

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def new
      @post = Post.new(published_at: Time.current)
    end

    def create
      @post = Post.new(post_params)
      if @post.save
        redirect_to admin_posts_path, notice: '动态发布成功'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @post.update(post_params)
        redirect_to admin_posts_path, notice: '动态更新成功'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @post.destroy
      redirect_to admin_posts_path, notice: '动态已删除'
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :category, :published_at)
    end
  end
end
