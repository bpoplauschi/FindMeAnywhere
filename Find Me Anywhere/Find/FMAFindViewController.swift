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
    var localizationInProgress: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Find Me"
        
        let fmaImage = UIImage(named: "SearchButton")
        navigationItem.rightBarButtonItem = UIBarButtonItem.itemWith(image: fmaImage, target: self, action: #selector(didTapSearch(responder:)))
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(notification:)), name: .UIApplicationDidBecomeActive, object: nil)
        
        DispatchQueue.main.async {
            if let coordinate = self.locationManager?.location?.coordinate {
                var zoomLevel:Double = 15
                self.mapView.setCenterCoordinate(centerCoordinate: coordinate, zoomLevel: &zoomLevel, animated: true)
            }
        }
    }
    
    func applicationDidBecomeActive(notification:Notification) {
        if !localizationInProgress { return }

        // 2. get the SMS from UIPasteboard
        var latitude: Double = 0
        var longitude: Double = 0

        if let smsText = UIPasteboard.general.string {
            let components = smsText.components(separatedBy: " ")
            for component in components {
                if component.contains("lat") {
                    let lat = component.components(separatedBy: ":")[1]
                    latitude = Double(lat) ?? 0
                } else if component.contains("long") {
                    let long = component.components(separatedBy: ":")[1]
                    longitude = Double(long) ?? 0
                }
            }
        }
        
        if latitude == 0 && longitude == 0 {
            let alertController = UIAlertController(title: "No SMS in the pasteboard", message: "Did you forget to copy the SMS from the tracker?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { (_) in }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

            return
        }
        
        // 3. display location on the map
        print(latitude, longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        
        mapView.addAnnotation(annotation)
        localizationInProgress = false
        
        var zoomLevel:Double = 15
        self.mapView.setCenterCoordinate(centerCoordinate: annotation.coordinate, zoomLevel: &zoomLevel, animated: true)
    }
    
    func didTapSearch(responder: UIResponder) {
        // initiate localization
        // 1. call the number
        guard let phoneNumber = FMATrackersManager.sharedManager.devices[0]["phone"] else { return }
        guard let phoneURL = URL(string: "tel://" + phoneNumber) else { return }
        if UIApplication.shared.canOpenURL(phoneURL) {
            localizationInProgress = true
            UIApplication.shared.openURL(phoneURL)
        }
    }
}
