class ActivityLogsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_survey, except: [:summary_table]
  before_filter :find_activity_log, except: [:index, :new, :create]

  def new
    @activity_log = @survey.activity_logs.build
    @users = User.where(county_id: @survey.county_id)
  end

  def create
    user_id = params[:activity_log][:user_id]
    if params[:activity_log][:user_id].blank?
      user_id = current_user.id
    end
    params[:activity_log].delete(:user_id)

    @activity_log = @survey.activity_logs.build(params[:activity_log])
    @activity_log.user_id = user_id

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

  def summary_table
    @table = @activity_log.summary_table.sort_by { |x| x[0][:code] }
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
      if @survey
        @activity_log = @survey.activity_logs.accessible_to(current_user).find(params[:id])
      else
        @activity_log = ActivityLog.accessible_to(current_user).find(params[:id])
      end
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The record you were looking" +
          " for could not be found."
      redirect_to @survey
    end
end
