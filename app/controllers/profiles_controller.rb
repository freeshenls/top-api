class ProfilesController < ApplicationController
  before_action :authenticate_user!
  layout -> { false if request.headers["Turbo-Frame"].present? }

  def edit
    @user = current_user
    @field = params[:field]
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      respond_to do |format|
        format.html { redirect_to member_path(@user), notice: "个人资料已更新" }
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:nickname, :bio, :skills, :expectations)
  end
end
