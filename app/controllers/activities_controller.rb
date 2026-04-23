class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all.order(event_date: :asc)
  end

  def show
    @activity = Activity.find(params[:id])
  end
end
