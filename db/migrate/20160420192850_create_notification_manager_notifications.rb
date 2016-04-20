class CreateNotificationManagerNotifications < ActiveRecord::Migration
  def change
    create_table :notification_manager_notifications do |t|
      t.string :change
      t.datetime :time_changed
      t.boolean :change_cancelled
      t.datetime :change_notified
      t.string :change_owner
      t.string :change_target
      t.string :change_context
      
      t.timestamps
    end
  end
end
