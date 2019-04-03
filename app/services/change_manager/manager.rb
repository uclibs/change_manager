module ChangeManager
  module Manager

    def queue_change(owner, change_type, context, target)
      change_id = Change.new_change(owner, change_type, context, target)
      ChangeManager::ProcessChangeJob.set(wait: 15.seconds).perform_later(change_id)
    end

    def process_change(change_id)
      change = Change.find change_id
      unless change.cancelled?
        verified_changes = process_changes_similar_to change
        notify_target_of verified_changes unless verified_changes.empty?
        true
      end
    end

    def process_changes_similar_to(change)
      similar_changes = group_similar_changes(change.owner, change.target)
      similar_changes = cancel_inverse_changes_in similar_changes if similar_changes.length > 1
      similar_changes
    end

    def group_similar_changes(owner, target)
      similar_changes = Change.where(owner: owner, target: target, cancelled: false, notified: nil)
    end

    def cancel_inverse_changes_in(similar_changes)
      similar_changes.each_with_index do |change, index|
          next_change = similar_changes[index+1]
          if next_change != nil and change.inverse_of?(next_change)
            change.cancel
            next_change.cancel
            similar_changes = similar_changes.to_a.delete_if { |change| change.cancelled? }
          end
      end
      similar_changes
    end

    def notify_target_of(changes)
      mailer = ChangeManager::NotificationMailer
        if mailer.send_email(mailer.construct_email(changes))
          changes.each { |change| change.notify }
          return true
        end
      false
    end
  end
end
