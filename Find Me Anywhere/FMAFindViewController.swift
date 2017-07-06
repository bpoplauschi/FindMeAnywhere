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
        // Do any additional setup after loading the view, typically from a nib.
        title = "Find Me Anywhere"
        
        let fmaImage = UIImage(named: "SearchButton")
        navigationItem.rightBarButtonItem = UIBarButtonItem.itemWith(image: fmaImage, target: self, action: #selector(didTapSearch(responder:)))
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
    }
    
    func didTapSearch(responder: UIResponder) {
        if let coordinate = locationManager?.location?.coordinate {
//            let newRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
//            
//            mapView.setRegion(newRegion, animated: true)
            var zoomLevel:Double = 15
            mapView.setCenterCoordinate(centerCoordinate: coordinate, zoomLevel: &zoomLevel, animated: true)
        }
    }
}


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

let MERCATOR_OFFSET = 268435456.0
let MERCATOR_RADIUS = 85445659.44705395
let DEGREES = 180.0

extension MKMapView {
    //MARK: Map Conversion Methods
    private func longitudeToPixelSpaceX(longitude:Double)->Double{
        return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * Double.pi / DEGREES)
    }
    
    private func latitudeToPixelSpaceY(latitude:Double)->Double{
        return round(MERCATOR_OFFSET - MERCATOR_RADIUS * log((1 + sin(latitude * Double.pi / DEGREES)) / (1 - sin(latitude * Double.pi / DEGREES))) / 2.0)
    }
    
    private func pixelSpaceXToLongitude(pixelX:Double)->Double{
        return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * DEGREES / Double.pi
        
    }
    
    private func pixelSpaceYToLatitude(pixelY:Double)->Double{
        return (Double.pi / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * DEGREES / Double.pi
    }
    
    private func coordinateSpanWithCenterCoordinate(centerCoordinate:CLLocationCoordinate2D, zoomLevel:Double)->MKCoordinateSpan{
        
        // convert center coordiate to pixel space
        let centerPixelX = longitudeToPixelSpaceX(longitude: centerCoordinate.longitude)
        let centerPixelY = latitudeToPixelSpaceY(latitude: centerCoordinate.latitude)
        
        // determine the scale value from the zoom level
        let zoomExponent:Double = 20.0 - zoomLevel
        let zoomScale:Double = pow(2.0, zoomExponent)
        
        // scale the map’s size in pixel space
        let mapSizeInPixels = self.bounds.size
        let scaledMapWidth = Double(mapSizeInPixels.width) * zoomScale
        let scaledMapHeight = Double(mapSizeInPixels.height) * zoomScale
        
        // figure out the position of the top-left pixel
        let topLeftPixelX = centerPixelX - (scaledMapWidth / 2.0)
        let topLeftPixelY = centerPixelY - (scaledMapHeight / 2.0)
        
        // find delta between left and right longitudes
        let minLng = pixelSpaceXToLongitude(pixelX: topLeftPixelX)
        let maxLng = pixelSpaceXToLongitude(pixelX: topLeftPixelX + scaledMapWidth)
        let longitudeDelta = maxLng - minLng
        
        let minLat = pixelSpaceYToLatitude(pixelY: topLeftPixelY)
        let maxLat = pixelSpaceYToLatitude(pixelY: topLeftPixelY + scaledMapHeight)
        let latitudeDelta = -1.0 * (maxLat - minLat)
        
        return MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
    
    func setCenterCoordinate(centerCoordinate:CLLocationCoordinate2D, zoomLevel: inout Double, animated:Bool){
        // clamp large numbers to 28
        zoomLevel = min(zoomLevel, 28)
        
        // use the zoom level to compute the region
        let span = self.coordinateSpanWithCenterCoordinate(centerCoordinate: centerCoordinate, zoomLevel: zoomLevel)
        let region = MKCoordinateRegionMake(centerCoordinate, span)
        if region.center.longitude == -180.00000000{
            print("Invalid Region")
        } else{
            self.setRegion(region, animated: animated)
        }
    }
    
}
