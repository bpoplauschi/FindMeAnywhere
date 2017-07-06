//
//  UIBarButtonItem+Additions.swift
//  Find Me Anywhere
//
//  Created by Bogdan Poplauschi on 06/07/2017.
//  Copyright © 2017 Find Me Anywhere. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func itemWith(image: UIImage?, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
}
