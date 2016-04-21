require_dependency "notification_manager/application_controller"

module NotificationManager
  class NotificationsController < ApplicationController
    before_action :set_notification, only: [:show, :edit, :update, :destroy]


    def new
      @notification = Notification.new
    end

    def create
      byebug
    end

    def update
      if @notification.update(notification_params)
        redirect_to @notification, notice: 'Notification was successfully updated.'
      else
        render action: 'edit'
      end
    end
    
    #method to do the create method + starting worker

    def destroy
      @notification.destroy
      redirect_to notifications_url, notice: 'Notification was successfully destroyed.'
    end

    def send_emails(constructed_email)
      # send the actual email
      constructed_email.deliver
    end

    def construct_email(target_email, changes)
      #use a passed array/hash type to construct the email body for all 
      #changes concerning a user
      body = prepare_body(changes)
      #mailer here
    end
    def prepare_body(changes)

    end
# dont need this
    def queue_job(change_id, delay, delay_type)
      # start the redis worker with needed delay
      Resque.enqueue(MakeChange, change_id, delay, delay_type)
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
