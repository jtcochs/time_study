class ActivityLogsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_survey
  before_filter :find_activity_log, only: [:show, :edit, :update, :destroy]

  def new
    @activity_log = @survey.activity_logs.build
  end

  def create
    @activity_log = @survey.activity_logs.build(params[:activity_log])
    @activity_log.user = current_user
    if @activity_log.save
      @activity_log.create_log_entries
      flash[:success] = "Activity log has been created."
      redirect_to [@survey, @activity_log]
    else
      flash[:error] = "Activity log has not been created."
      render :new
    end
  end

  def show
    if @activity_log.unconfirmed
      render :edit
    end
  end

  def edit
  end

  def update
    create_entries = true if @activity_log.unconfirmed
    @activity_log.unconfirmed = false
    if @activity_log.update_attributes(params[:activity_log])
      @activity_log.create_log_entries if create_entries
      flash[:success] = "Activity log has been updated."
      redirect_to [@survey, @activity_log]
    else
      flash[:error] = "Activity log has not been updated."
      render :edit
    end
  end

  def destroy
    @activity_log.destroy
    flash[:notice] = "Activity Log has been deleted."
    redirect_to @survey
  end

  private
    def find_survey
      @survey = Survey.find(params[:survey_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The survey you were looking" +
          " for could not be found."
      redirect_to surveys_path
    end

    def find_activity_log
      @activity_log = @survey.activity_logs.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The record you were looking" +
          " for could not be found."
      redirect_to @survey
    end
end
