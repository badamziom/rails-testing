class AchievementsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :owner_only, only: [:edit, :update, :destroy]

  def index
    @achievements = Achievement.get_public_achievements
  end

  def new
    @achievement = Achievement.new
  end

  def edit; end

  def update
    if @achievement.update_attributes(achievement_params)
      redirect_to achievement_path(@achievement)
    else
      render :edit
    end
  end

  def create
    service = CreateAchievement.new(params[:achievement], current_user)
    service.create
    if service.created?
      redirect_to achievement_path(service.achievement), notice: 'Achievement has been created'
    else
      @achievement = service.achievement
      render :new
    end

  end

  def show
    @achievement = Achievement.find(params[:id])
  end

  def destroy
    @achievement.destroy
    redirect_to achievement_path
  end

  private

  def achievement_params
    params.require(:achievement).permit(:title, :description, :privacy, :cover_image, :featured)
  end

  def owner_only
    @achievement = Achievement.find(params[:id])
    if current_user != @achievement.user
      redirect_to achievement_path
    end
  end
end