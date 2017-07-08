//
//  FMALocalNotificationsScheduler.swift
//  Find Me Anywhere
//
//  Created by Oana Popescu on 08/07/17.
//  Copyright © 2017 Find Me Anywhere. All rights reserved.
//

import UIKit

class FMALocalNotificationsScheduler {
    
    // MARK: Register for notifications
    
    static func registerForNotifications() {
        if let currentSettings = UIApplication.shared.currentUserNotificationSettings?.types,
            currentSettings.isEmpty {
            // Not registered
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    static func scheduledNotifications() -> Array<FMAReminder> {
        var reminders: Array<FMAReminder> = []
        if let scheduledNotifications = UIApplication.shared.scheduledLocalNotifications {
            for notif in scheduledNotifications {
                let reminder = FMAReminder()
                reminder.name = notif.userInfo?["name"] as? String ?? ""
                reminder.date = notif.userInfo?["date"] as? Date ?? Date()
                if let frequence = notif.userInfo?["repeatInterval"] as? UInt {
                    let calendar = NSCalendar.Unit(rawValue: frequence)
                    reminder.frequence = calendar
                }
                reminder.localNotification = notif

                reminders.append(reminder)
            }
        }
        return reminders
    }
    
    static func cancel(reminder: FMAReminder) {
        if let notif = reminder.localNotification {
            UIApplication.shared.cancelLocalNotification(notif)
        }
    }
    
    static func schedule(reminder: FMAReminder) {
        self.schedule(date: reminder.date, repeatInterval: reminder.frequence, name: reminder.name)
    }
    
    fileprivate static func schedule(date: Date, repeatInterval: NSCalendar.Unit, name: String) {
        let localNotif = UILocalNotification()
        localNotif.fireDate = date
        localNotif.alertBody = "Make sure " + name + " is ok"
        localNotif.alertTitle = "Reminder"
        localNotif.soundName = UILocalNotificationDefaultSoundName
        localNotif.repeatInterval = repeatInterval
        
        let reminder = FMAReminder()
        reminder.name = name
        reminder.date = date
        reminder.frequence = repeatInterval
        reminder.localNotification = localNotif
        
        localNotif.userInfo = ["name" : name, "date" : date, "repeatInterval": repeatInterval.rawValue]
        
        UIApplication.shared.scheduleLocalNotification(localNotif)
    }
}
