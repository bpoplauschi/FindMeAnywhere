//
//  FMATrackersViewController.swift
//  Find Me Anywhere
//
//  Created by Bogdan Poplauschi on 06/07/2017.
//  Copyright © 2017 Find Me Anywhere. All rights reserved.
//

import UIKit

class FMATrackersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trackers"
        let nib = UINib(nibName: "FMATrackerTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "trackerCellID")
    }
    
    @IBAction func didTapAdd(_ sender: Any) {
        let alertController = UIAlertController(title: "New device", message: "Please input the phone number and a device name:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let phoneNumber = alertController.textFields?[0].text, let name = alertController.textFields?[1].text {
                FMATrackersManager.sharedManager.addDevice(name: name, phoneNumber: phoneNumber)
                self.tableView.reloadData()
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Phone number"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension FMATrackersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FMATrackersManager.sharedManager.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: FMATrackerTableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "trackerCellID") as? FMATrackerTableViewCell {
            cell = dequeuedCell
        } else {
            cell = FMATrackerTableViewCell()
        }
    
        cell.iconImageView?.image = UIImage(named: "Tracker")
        let device = FMATrackersManager.sharedManager.devices[indexPath.row]
        cell.phoneNumberLabel?.text = device["phone"] ?? ""
        cell.nameLabel?.text = device["name"] ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let deviceName = FMATrackersManager.sharedManager.devices[indexPath.row]["name"] {
                FMATrackersManager.sharedManager.deleteDevice(name: deviceName)
                tableView.reloadData()
            }
        }
    }
}
