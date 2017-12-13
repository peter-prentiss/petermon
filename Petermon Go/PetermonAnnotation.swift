//
//  PetermonAnnotation.swift
//  Petermon Go
//
//  Created by admin on 12/13/17.
//  Copyright © 2017 Peter Prentiss. All rights reserved.
//

import UIKit
import MapKit

class PetermonAnnotation : NSObject, MKAnnotation {
    var coordinate : CLLocationCoordinate2D
    var petermon : Petermon
    
    init(coord:CLLocationCoordinate2D, petermon:Petermon) {
        self.coordinate = coord
        self.petermon = petermon
    }
}
