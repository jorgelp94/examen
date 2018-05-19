//
//  BranchAnnotation.swift
//  banregio
//
//  Created by Jorge Luis Perales on 5/19/18.
//  Copyright © 2018 Jorge Perales. All rights reserved.
//

import MapKit

class BranchAnnotation: NSObject, MKAnnotation {
    var branch: Branch
    var coordinate: CLLocationCoordinate2D { return branch.location }
    
    init(branch: Branch) {
        self.branch = branch
        super.init()
    }
    
    var title: String? {
        return branch.name
    }
    
    var subtitle: String? {
        return branch.address
    }
    
    var markerTintColor: UIColor {
        switch branch.type {
        case "S":
            return ColorPalette.orange
        case "C":
            return .black
        default:
            return ColorPalette.orange
        }
    }
}
