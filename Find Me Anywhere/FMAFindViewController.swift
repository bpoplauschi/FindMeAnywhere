//
//  FMAFindViewController.swift
//  Find Me Anywhere
//
//  Created by Bogdan Poplauschi on 22/05/2017.
//  Copyright © 2017 Find Me Anywhere. All rights reserved.
//

import UIKit
import MapKit

class FMAFindViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Find Me Anywhere"
        
        let fmaImage = UIImage(named: "SearchButton")
        navigationItem.rightBarButtonItem = UIBarButtonItem.itemWith(image: fmaImage, target: self, action: #selector(didTapSearch(responder:)))
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
    }
    
    func didTapSearch(responder: UIResponder) {
        if let coordinate = locationManager?.location?.coordinate {
            var zoomLevel:Double = 15
            mapView.setCenterCoordinate(centerCoordinate: coordinate, zoomLevel: &zoomLevel, animated: true)
        }
    }
}
