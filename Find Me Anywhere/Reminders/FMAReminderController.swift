//
//  FMAReminderController.swift
//  Find Me Anywhere
//
//  Created by Oana Popescu on 08/07/17.
//  Copyright © 2017 Find Me Anywhere. All rights reserved.
//

import UIKit

fileprivate enum ReminderRow: Int {
    case name
    case date
    case repeatInterval
    case count
}

protocol FMAReminderControllerDelegate: class {
    func didSave(in controller: FMAReminderController, reminder: FMAReminder)
}

class FMAReminderController: UITableViewController, DatePickerCellDelegate, FMAChoicePickerControllerDelegate {
    fileprivate let reminder: FMAReminder
    fileprivate static let dateFormatter = DateFormatter()
    fileprivate let dateCell = DatePickerCell(style: .value1, reuseIdentifier: "reuseDateCell")

    weak var delegate: FMAReminderControllerDelegate?
    
    init(reminder: FMAReminder) {
        self.reminder = reminder
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let saveItem = UIBarButtonItem(barButtonSystemItem: .save,
                                       target: self,
                                       action: #selector(saveTapped(sender:)))
        self.navigationItem.rightBarButtonItem = saveItem
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReminderRow.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell(style: .value1, reuseIdentifier: "reuseID")

        if let type = ReminderRow(rawValue: indexPath.row) {
            switch type {
            case .name:
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseID")
                cell.detailTextLabel?.text = self.reminder.name
                cell.textLabel?.text = "Name"
            case .date:
                dateCell.dateFormat = self.reminder.frequence.dateFormat()
                dateCell.date = self.reminder.date
                dateCell.leftLabel.text = "Date"
                dateCell.delegate = self
                cell = dateCell
            case .repeatInterval:
                cell.detailTextLabel?.text = self.reminder.frequence.displayValue()
                cell.textLabel?.text = "Repeat interval"
            default:
                break
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let type = ReminderRow(rawValue: indexPath.row) {
            switch type {
            case .name:
                self.presentEditName()
            case .date:
                if let cell = tableView.cellForRow(at: indexPath) as? DatePickerCell {
                    cell.selectedInTableView(tableView)
                }
            case .repeatInterval:
                let controller = FMAChoicePickerController(items: [NSCalendar.Unit.day, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.month],
                                                           selectedItem: self.reminder.frequence)
                controller.title = "Frequency"
                controller.delegate = self
                self.navigationController?.pushViewController(controller, animated: true)
            default:
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let type = ReminderRow(rawValue: indexPath.row),
            type == .date {
            return dateCell.datePickerHeight()
        }
        return UITableViewAutomaticDimension
    }
    
    // MARK: Helper methods
    
    fileprivate func presentEditName() {
        let alertController = UIAlertController(title: "Name", message: "Please input the name of the person:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let name = alertController.textFields?[0].text {
                self.reminder.name = name
                self.tableView.reloadData()
            } else {
                // user did not fill field
            }
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.text = self.reminder.name
        }
        
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Target-action
    
    func saveTapped(sender: UIBarButtonItem) {
        self.delegate?.didSave(in: self, reminder: self.reminder)
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: DatePickerCellDelegate
    
    @objc func datePickerCell(_ cell: DatePickerCell, didPickDate date: Date?) {
        if let date = date {
            self.reminder.date = date
        }
    }
    
    // MARK: FMAChoicePickerControllerDelegate

    func didChangeSelection(in controller: FMAChoicePickerController, selected: ChoicePickerItem) {
        if let unit = selected as? NSCalendar.Unit {
            self.reminder.frequence = unit
        }
        self.tableView.reloadData()
    }
}
