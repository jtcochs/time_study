class Api::V1::LogEntriesController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  before_filter :authenticate_user!

  respond_to :json
	
	def index
		if activity_log = ActivityLog.where(user_id: current_user.id).first
			render status: :ok,
             json: { success: true,
                        info: "Request successful.",
                        data: activity_log.recent_log_entry_dates }
		else
			respond_with({ error: "No log entries." })
		end
	end

	def create
		activity_log = ActivityLog.where(user_id: current_user.id).first
		date = Date.parse(params[:log_entry][:date]) if params[:log_entry][:date]
		log_entry = activity_log.log_entries.where(date: date).first
		log_entry.destroy if log_entry

		log_entry = activity_log.log_entries.build(params[:log_entry])
		if log_entry.save
		# if log_entry
		  render :status => :created,
             :json => { :success => true,
                        :info => "Log entry successfully submitted.",
                        :data => {} }
	    else
	      render :status => :ok,
	             :json => { :success => false,
                 :info => log_entry.errors,
                 :data => {} }
    	end
	end
end