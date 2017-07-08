//
//  FMAChoicePickerController.swift
//  Find Me Anywhere
//
//  Created by Oana Popescu on 08/07/17.
//  Copyright © 2017 Find Me Anywhere. All rights reserved.
//

import UIKit

protocol ChoicePickerItem {
    func displayTitle() -> String
    func isEqual(item: ChoicePickerItem) -> Bool
}

extension NSCalendar.Unit: ChoicePickerItem {
    func displayTitle() -> String {
        return self.displayValue()
    }
    
    func isEqual(item: ChoicePickerItem) -> Bool {
        if let item = item as? NSCalendar.Unit {
            return self.rawValue == item.rawValue
        }
        return false
    }
}

protocol FMAChoicePickerControllerDelegate: class {
    func didChangeSelection(in controller: FMAChoicePickerController, selected: ChoicePickerItem)
}

// One section single selection
class FMAChoicePickerController: UITableViewController {
    fileprivate let items: Array<ChoicePickerItem>
    fileprivate var selectedItem: ChoicePickerItem
    
    weak var delegate: FMAChoicePickerControllerDelegate?
    
    init(items: Array<ChoicePickerItem>, selectedItem: ChoicePickerItem) {
        self.items = items
        self.selectedItem = selectedItem
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: "cellID") {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "reuseID")
        }
        
        let item = self.items[indexPath.row]
        cell.textLabel?.text = item.displayTitle()
        if (item.isEqual(item: self.selectedItem)) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.selectionStyle = .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        self.selectedItem = item
        self.tableView.reloadData()
        
        self.delegate?.didChangeSelection(in: self, selected: self.selectedItem)
    }

}
