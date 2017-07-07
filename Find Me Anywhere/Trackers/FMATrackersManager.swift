//
//  FMATrackersManager.swift
//  Find Me Anywhere
//
//  Created by Bogdan Poplauschi on 07/07/2017.
//  Copyright © 2017 Find Me Anywhere. All rights reserved.
//

import Foundation

class FMATrackersManager {
    static let sharedManager = FMATrackersManager()
    
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
    }
}
