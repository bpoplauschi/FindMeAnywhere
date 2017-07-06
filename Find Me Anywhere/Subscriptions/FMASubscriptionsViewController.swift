//
//  FMASubscriptionsViewController.swift
//  Find Me Anywhere
//
//  Created by Bogdan Poplauschi on 06/07/2017.
//  Copyright © 2017 Find Me Anywhere. All rights reserved.
//

import UIKit

class FMASubscriptionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let subscriptions = [["title": "Weekly subscription",
                          "price": "$1",
                          "description": "pay week by week"],
                         ["title": "Monthly subscription",
                          "price": "$3",
                          "description": "pay once for each month"],
                         ["title": "Yearly subscription",
                          "price": "$30",
                          "description": "pay once for the whole year"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Subscriptions"
    }
}

extension FMASubscriptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseID")
        
        cell.textLabel?.text = "\(String(describing: subscriptions[indexPath.row]["title"]!)) - at \(String(describing: subscriptions[indexPath.row]["price"]!))"
        cell.detailTextLabel?.text = subscriptions[indexPath.row]["description"]
        
        return cell
    }
}
