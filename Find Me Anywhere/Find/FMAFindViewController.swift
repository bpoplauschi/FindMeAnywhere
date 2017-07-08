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
    var localizationPhoneNumber: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Find Me"
        mapView.delegate = self
        
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
        var dateString: String = ""
        
        // SMS format 1
//        last:
//        lat:46.92542 long:25.35536 speed:000.0
//        T:07/04/17 17:20
//        http://maps.google.com/maps?f=q&q=46.92542,25.35536&z=16
//        now:
//        lac:12200
//        cid:12836 
//        mcc=226  
//        mnc=010
        
        // SMS format 2
//        lat:46.92550 long:25.35536 speed:000.0
//        T:07/04/17 17:09

        if let smsText = UIPasteboard.general.string {
            let lines = smsText.components(separatedBy: "\n")
            for line in lines {
                let components = line.components(separatedBy: " ")
                for component in components {
                    if component.contains("lat") {
                        let lat = component.components(separatedBy: ":")[1]
                        latitude = Double(lat) ?? 0
                    } else if component.contains("long") {
                        let long = component.components(separatedBy: ":")[1]
                        longitude = Double(long) ?? 0
                    }
                }
                if line.hasPrefix("T:") {
                    let index = line.index(line.startIndex, offsetBy: 2)
                    dateString = line.substring(from: index)
                }
            }
        }
        
        if latitude == 0 && longitude == 0 {
            return
        }
        
        // 3. display location on the map
        print(latitude, longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        if let localizationPhoneNumber = localizationPhoneNumber {
            annotation.title = "Tracker: \(localizationPhoneNumber)"
        }
        annotation.subtitle = "Date: \(dateString)"
        
        mapView.removeAnnotations(mapView.annotations)
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
        localizationInProgress = true
        localizationPhoneNumber = phoneNumber
        if UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.openURL(phoneURL)
        }
    }
}

extension FMAFindViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView: MKAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
}
