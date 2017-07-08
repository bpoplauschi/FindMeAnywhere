//
//  FMARemindersViewController.swift
//  Find Me Anywhere
//
//  Created by Bogdan Poplauschi on 06/07/2017.
//  Copyright © 2017 Find Me Anywhere. All rights reserved.
//

import UIKit

class FMARemindersViewController: UIViewController, FMAReminderControllerDelegate {
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!

    fileprivate var reminders: Array<FMAReminder> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reminders"
        
        // Register
        FMALocalNotificationsScheduler.registerForNotifications()
        
        self.updateReminders()
    }
    
    // MARK: Target-action
    
    @IBAction func didTapAdd(_ sender: Any) {
        // Default reminder
        let reminder = FMAReminder()
        let reminderController = FMAReminderController(reminder: reminder)
        reminderController.title = "Add reminder"
        reminderController.delegate = self
        self.navigationController?.pushViewController(reminderController, animated: true)
    }
    
    // MARK: FMAReminderControllerDelegate methods
    
    func didSave(in controller: FMAReminderController, reminder: FMAReminder) {
        if let _ = reminder.localNotification {
            FMALocalNotificationsScheduler.cancel(reminder: reminder)
        }
        FMALocalNotificationsScheduler.schedule(reminder: reminder)
        self.updateReminders()
    }
    
    fileprivate func updateReminders() {
        self.reminders = FMALocalNotificationsScheduler.scheduledNotifications().sorted(by: {$0.name < $1.name})
        self.tableView.reloadData()
    }
}

extension FMARemindersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: "reuseID") {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "reuseID")
        }
        
        let reminder = self.reminders[indexPath.row]
        cell.textLabel?.text = reminder.name
        cell.detailTextLabel?.text = reminder.frequence.displayValue()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if (indexPath.row < self.reminders.count) {
                let reminder = self.reminders[indexPath.row]
                FMALocalNotificationsScheduler.cancel(reminder: reminder)
                self.updateReminders()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row < self.reminders.count) {
            let reminder = self.reminders[indexPath.row]
            let reminderController = FMAReminderController(reminder: reminder)
            reminderController.title = reminder.name
            reminderController.delegate = self
            self.navigationController?.pushViewController(reminderController, animated: true)
        }
    }
}
