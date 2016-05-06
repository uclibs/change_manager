# Notification Manager
Notification Manager is a simple all-in-one system for starting, storing, and comparing ActiveRecord objects using Resque and resque-scheduler. It also features and supports rspec. All tests in this gem are written with rspec. 

While Resque itself is pretty simple to implement, this packages Resque, resque-scheduler together with some simple common sense logic for comparing objects. I wrote this to simplify some functionality in my own applications, so some of it is application-specific. However, I tried to construct this gem in a way that would make customization easy. ___I welcome anyone and everyone that happens to find this useful to add your own customizations to it. All you need to do is fork the repo, make your changes, and create a Pull Request.___ Understandably, I would like any customizations made to have matching specs.

## Run-down of how NotificationManager works:
I don't like complicated code. I don't think anyone does. Therefore, NotificationManager is written with a 'no nonsense' style. First, you must create a Notification object using `NotificationManager::Manager.notification()` like so:
(app/services/notification_manager/manager.rb)
```
NotificationManager::Manager.notification(owner, change_type, context, target)
```

### Properties:

`owner` - string. This value is arbitrary and is generally an email address, though you can use a `User` object if you create a custom Notification model (or modify the existing model). `owner` is the entity making the change to `target`

`change_type` - string. This value has to be one of the predefined change types located in `config/change_types.yaml`. You can add your own custom change types very easily as long as each change's values are defined in a dictionary of dictionaries (I'll go over this more soon.)

`context` - string. This value is also arbitrary and can be anything you want. It is intended to be used for an id of some Model. It's mostly application specific so that's about as specific as it gets. You can also pass it an empty string - context is not a required argument.

`target` - string. This value is arbitrary and similar to `owner`: Can be whatever you want, but generally an email address or some sort of identifier. `target` is the entity on the receiving end of the change made by `owner`.

___Real-world example:___

`NotificationManager::Manager.notification('kyle', 'added_as_editor', 'some_random_id', 'chris')`

Generates a Notification object with the attributes:

```
owner: 'kyle' 
change_type: 'added_as_editor' 
context: 'some_random_id' 
target: 'chris'
cancelled: cancelled #all notifications are not cancelled by default.
```

This works by calling the actual constructor for the `Notification` object and then scheduling the MakeChange job to be queued 15 minutes from the current date/time:

```
Resque.enqueue_in(15.minutes, MakeChange, change_id)

...

#make_change.rb:
def self.perform(change_id)
    NotificationManager::Manager.notify(change_id)
end
```

All this job does is call the `notify` method and passing it the id of the `Notification` object from before. The `notify` method does an initial check to see if the notification was cancelled. If it is cancelled, the flow ends there, nothing else happens. If it was not, it collects any other changes in an array from the database where the `owner` and `target` are the same and where `cancelled` is false.

`similar_changes = Notification.where(owner: owner, target: target, cancelled: false)`

If there are no other changes that match this criteria, the change is packaged up into an email and sent inside of a nicely formatted table to `target` (hence why target is generally an email address). If there are similar changes to be found, it passes it to another method in the Manager `cancel_inverse_changes`.
