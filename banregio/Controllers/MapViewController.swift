//
//  MapViewController.swift
//  banregio
//
//  Created by Jorge Luis Perales on 5/19/18.
//  Copyright © 2018 Jorge Perales. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var branches = [Branch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = ColorPalette.orange
        self.navigationItem.title = "Sucursales y Cajeros"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white, NSAttributedStringKey.font: UIFont(name: "CircularStd-Book", size: 20)!]
        map.showsUserLocation = true
        map.delegate = self
        requestLocationAccess()
        loadMapAnnotations()
    }
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.zoomIntoLocation()
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func zoomIntoLocation() {
        let location = locationManager.location
        let viewRegion = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, 10000, 10000)
        map.setRegion(viewRegion, animated: true)
    }
    
    func loadMapAnnotations() {
        for branch in self.branches {
            let bAnnotation = BranchAnnotation(branch: branch)
            map.addAnnotation(bAnnotation)
        }
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? BranchAnnotation else { return nil }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = map.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.markerTintColor = annotation.markerTintColor
        }
        return view
    }
}
