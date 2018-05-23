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
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var branches = [Branch]()
    var resultBranches = [Branch]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sucursales y Cajeros"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white, NSAttributedStringKey.font: UIFont(name: "CircularStd-Book", size: 20)!]
        map.showsUserLocation = true
        map.delegate = self
        requestLocationAccess()
        loadMapAnnotations()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Búsqueda"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
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
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.resultBranches = branches.filter {
            $0.city.contains(searchText)
        }
        for result in self.resultBranches {
            print(result.city)
            print(result.id)
        }
        
        self.tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

extension MapViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            self.tableView.isHidden = false
        } else {
            self.tableView.isHidden = true
        }
        self.filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return resultBranches.count
        }
        return branches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchResultsTableViewCell
        let branch: Branch
        if isFiltering() {
            branch = resultBranches[indexPath.row]
        } else {
            branch = branches[indexPath.row]
        }
        cell.titleLabel.text = branch.name
        cell.addressLabel.text = branch.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let branch: Branch
        if isFiltering() {
            branch = resultBranches[indexPath.row]
        } else {
            branch = branches[indexPath.row]
        }
        var annotations = self.map.annotations
        print(annotations.self)
        var newAnnotations = [BranchAnnotation]()
        for annotation in annotations {
            if annotation .isMember(of: BranchAnnotation.self) {
                newAnnotations.append(annotation as! BranchAnnotation)
            }
        }
        
        let filtered = newAnnotations.filter {
            $0.branch.id == branch.id
        }
        self.tableView.isHidden = true
        self.map.selectAnnotation(filtered[0], animated: true)
        self.map.setCenter(filtered[0].coordinate, animated: true)
    }
}
