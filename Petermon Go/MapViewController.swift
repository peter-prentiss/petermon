//
//  ViewController.swift
//  Petermon Go
//
//  Created by admin on 12/12/17.
//  Copyright © 2017 Peter Prentiss. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            if let center = manager.location?.coordinate {
                let region = MKCoordinateRegionMakeWithDistance(center, 1000, 1000)
                mapView.setRegion(region, animated: false)
            }
            updateCount += 1
        }
        
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let center = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(center, 1000, 1000)
            mapView.setRegion(region, animated: true)
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
}

