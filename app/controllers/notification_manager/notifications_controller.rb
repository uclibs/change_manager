require_dependency "notification_manager/application_controller"

module NotificationManager
  class NotificationsController < ApplicationController
    before_action :set_notification, only: [:show, :edit, :update, :destroy]

    # GET /notifications
    def index
      @notifications = Notification.all
    end

    # GET /notifications/1
    def show
    end

    # GET /notifications/new
    def new
      @notification = Notification.new
    end

    # GET /notifications/1/edit
    def edit
    end

    # POST /notifications
    def create
      @notification = Notification.new(notification_params)

      if @notification.save
        redirect_to @notification, notice: 'Notification was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /notifications/1
    def update
      if @notification.update(notification_params)
        redirect_to @notification, notice: 'Notification was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /notifications/1
    def destroy
      @notification.destroy
      redirect_to notifications_url, notice: 'Notification was successfully destroyed.'
    end

    def send_emails(owner, target, change_type, context)
      # send the actual email
    end

    def construct_email(changes)
      #use a passed array/hash type to construct the email body for all 
      #changes concerning a user
    end

    def start_worker(change_id, delay, delay_type)
      # start the redis worker with needed delay
    end

    def cancel_change(change_id)
      # cancel the change in the model
      # notification.change_cancelled = true
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_notification
        @notification = Notification.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def notification_params
        params[:notification]
      end
  end
end
