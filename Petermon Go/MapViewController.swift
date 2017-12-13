//
//  ViewController.swift
//  Petermon Go
//
//  Created by admin on 12/12/17.
//  Copyright © 2017 Peter Prentiss. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    
    var petermons : [Petermon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petermons = getAllPetermon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            mapView.delegate = self
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if let center = self.manager.location?.coordinate {
                var annoCoord = center
                annoCoord.latitude += (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                annoCoord.longitude += (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                
                let randomIndex = Int(arc4random_uniform(UInt32(self.petermons.count)))
                
                let randomPetermon = self.petermons[randomIndex]
                
                let anno = PetermonAnnotation(coord: annoCoord, petermon: randomPetermon)
                self.mapView.addAnnotation(anno)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annoView.image = UIImage(named: "player")
            var frame = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            annoView.frame = frame
        } else {
            if let petermonAnnotation = annotation as? PetermonAnnotation {
                if let imageName = petermonAnnotation.petermon.imageName {
                    annoView.image = UIImage(named: imageName)
                    var frame = annoView.frame
                    frame.size.height = 50
                    frame.size.width = 50
                    annoView.frame = frame
                }
            }
        }
        
        return annoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        if view.annotation is MKUserLocation {
            
        } else {
            if let center = manager.location?.coordinate {
                if let petermonCenter = view.annotation?.coordinate {
                    let region = MKCoordinateRegionMakeWithDistance(petermonCenter, 200, 200)
                    mapView.setRegion(region, animated: false)
                    
                    if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(center)) {
                        
                        if let petermonAnnotation = view.annotation as? PetermonAnnotation {
                            petermonAnnotation.petermon.caught = true
                            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                                try? context.save()
                                if let name = petermonAnnotation.petermon.name {
                                    let alertVC = UIAlertController(title: "Congrats!", message: "You caught a \(name)", preferredStyle: .alert)
                                    
                                    let peterdexAction = UIAlertAction(title: "PeterDex", style: .default, handler: { (action) in
                                        self.performSegue(withIdentifier: "moveToPeterdex", sender: nil)
                                    })
                                    
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                                        alertVC.dismiss(animated: true, completion: nil)
                                    })
                                    
                                    alertVC.addAction(peterdexAction)
                                    alertVC.addAction(okAction)
                                    present(alertVC, animated: true, completion: nil)
                                }
                                
                            }
                        }
                    } else {
                        if let petermonAnnotation = view.annotation as? PetermonAnnotation {
                            if let name = petermonAnnotation.petermon.name {
                                let alertVC = UIAlertController(title: "Oops!", message: "You are too far away from the \(name) to catch it.", preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                                    alertVC.dismiss(animated: true, completion: nil)
                                })
                                
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            if let center = manager.location?.coordinate {
                let region = MKCoordinateRegionMakeWithDistance(center, 200, 200)
                mapView.setRegion(region, animated: false)
            }
            updateCount += 1
        }
        
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let center = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(center, 200, 200)
            mapView.setRegion(region, animated: true)
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
}

