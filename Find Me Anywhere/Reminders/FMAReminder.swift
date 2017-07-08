//
//  FMAReminder.swift
//  Find Me Anywhere
//
//  Created by Oana Popescu on 08/07/17.
//  Copyright © 2017 Find Me Anywhere. All rights reserved.
//

import UIKit

class FMAReminder {
    var name: String = ""
    var frequence: NSCalendar.Unit = .day
    var date: Date = Date().addingTimeInterval(120)
    var localNotification: UILocalNotification? = nil
}

extension NSCalendar.Unit {
    func displayValue() -> String {
        let display: String
        if self.contains(.day) {
            display = "Daily"
        } else if self.contains(.weekOfYear) {
            display = "Weekly"
        } else if self.contains(.month) {
            display = "Monthly"
        } else {
            display = ""
        }
        return display
    }
}
