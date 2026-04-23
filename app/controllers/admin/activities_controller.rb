module Admin
  class ActivitiesController < BaseController
    before_action :set_activity, only: [:edit, :update, :destroy]

    def index
      @activities = Activity.order(event_date: :desc)
      
      if params[:q].present?
        @activities = @activities.where("activity.title ILIKE :q OR activity.location ILIKE :q", q: "%#{params[:q]}%")
      end

      @pagy, @activities = pagy(:offset, @activities, items: 20)

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def new
      @activity = Activity.new(event_date: Date.tomorrow, status: 'open')
    end

    def create
      @activity = Activity.new(activity_params)
      if @activity.save
        redirect_to admin_activities_path, notice: '活动创建成功'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @activity.update(activity_params)
        redirect_to admin_activities_path, notice: '活动更新成功'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @activity.destroy
      redirect_to admin_activities_path, notice: '活动已删除'
    end

    private

    def set_activity
      @activity = Activity.find(params[:id])
    end

    def activity_params
      params.require(:activity).permit(:title, :description, :status, :event_date, :location)
    end
  end
end
