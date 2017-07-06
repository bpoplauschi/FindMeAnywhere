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
    }
    
    @IBAction func didTapAdd(_ sender: Any) {
        let alertController = UIAlertController(title: "New device", message: "Please input the phone number and a device name:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let phoneNumber = alertController.textFields?[0].text, let name = alertController.textFields?[1].text {
                self.addDevice(name: name, phoneNumber: phoneNumber)
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
    
    var devices: [[String: String]] {
        get {
            if let devices = UserDefaults.standard.array(forKey: "devices") as? [[String:String]] {
                return devices
            }
            return []
        }
    }
    
    func addDevice(name:String, phoneNumber:String) -> Void {
        var devices = UserDefaults.standard.array(forKey: "devices")
        if devices == nil {
            devices = []
        }
        devices?.append(["phone": phoneNumber, "name": name])
        UserDefaults.standard.set(devices, forKey: "devices")
        
        tableView.reloadData()
    }
    
    func deleteDevice(name:String) -> Void {
        guard var devices = UserDefaults.standard.array(forKey: "devices") else { return }
        var indexOfDeviceToDelete = 0
        for device in devices {
            if let device = device as? [String:String], let deviceName = device["name"], name == deviceName {
                break
            }
            indexOfDeviceToDelete += 1
        }
        if indexOfDeviceToDelete < devices.count {
            devices.remove(at: indexOfDeviceToDelete)
        }
        UserDefaults.standard.set(devices, forKey: "devices")
        
        tableView.reloadData()
    }
}

extension FMATrackersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "reuseID")
        
        let device = self.devices[indexPath.row]
        cell.textLabel?.text = device["phone"] ?? ""
        cell.detailTextLabel?.text = device["name"] ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let deviceName = self.devices[indexPath.row]["name"] {
                self.deleteDevice(name: deviceName)
            }
        }
    }
}
