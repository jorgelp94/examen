//
//  LoginViewController.swift
//  banregio
//
//  Created by Jorge Luis Perales on 5/16/18.
//  Copyright © 2018 Jorge Perales. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import CoreData
import SlideMenuControllerSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var branches = [Branch]()
    var users: [NSManagedObject] = []
    
    @objc func touchTapped(_ sender: UITapGestureRecognizer) {
        if let mapNavigationController = storyboard?.instantiateViewController(withIdentifier: "MapViewNavigationController") as? UINavigationController, let mapViewController = mapNavigationController.viewControllers.first as? MapViewController {
            mapViewController.branches = self.branches
            self.present(mapNavigationController, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.showsUserLocation = true
        map.delegate = self
        requestLocationAccess()
        downloadBranches()
        addGestureRecognizerToMap()
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
    
    func addGestureRecognizerToMap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped(_:)))
        map.addGestureRecognizer(tap)
    }
    
    func zoomIntoLocation() {
        let location = locationManager.location
        let viewRegion = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, 10000, 10000)
        map.setRegion(viewRegion, animated: true)
    }
    
    func downloadBranches() {
        Alamofire.request("\(baseUrl)\(Endpoints.branches.rawValue)").responseJSON { response in
            let jsonDecoder = JSONDecoder()
            do {
                let results = try jsonDecoder.decode(Array<Branch>.self, from:response.data!)
                self.branches = results
                InternalHelper.sharedInstance.branches = results
                self.loadMapAnnotations()
            } catch {
                print("caught: \(error)")
            }
        }
    }

    func attemptLogin(username: String, password: String) {
        Alamofire.request("\(baseUrl)\(Endpoints.login.rawValue)").responseJSON { response in
            if let json = response.result.value as? [String: AnyObject] {
                print("JSON: \(json)") // serialized json response
                if let user = json["user"] as? String, let pass = json["password"] as? String {
                    if user == username && pass == password {
                        self.presentNewViewController()
                    } else {
                        self.displayAlert(title: "Error", message: "Usuario y/o contraseña incorrectos. Intenta de nuevo.")
                    }
                }
            }
        }
    }
    
    func presentNewViewController() {
        if self.checkForPreviousSession() {
            presentMainMenu()
        } else {
            self.presentViewController(storyboardId: "RegisterNavigationViewController")
        }
    }
    
    func presentMainMenu() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeNavigationViewController")
        let leftViewController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController")
        let slideMenuController = SlideMenuController(mainViewController: homeViewController!, leftMenuViewController: leftViewController!)
        UIApplication.shared.keyWindow?.rootViewController = slideMenuController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    func presentViewController(storyboardId: String) {
        let controller = storyboard?.instantiateViewController(withIdentifier: storyboardId)
        self.present(controller!, animated: true, completion: nil)
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadMapAnnotations() {
        for branch in self.branches {
            let bAnnotation = BranchAnnotation(branch: branch)
            map.addAnnotation(bAnnotation)
        }
    }
    
    func checkForPreviousSession() -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let frequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
            users = try managedContext.fetch(frequest)
            if users.count > 0 {
                for user in users {
                    if let name = user.value(forKey: "name") as? String, let lastname = user.value(forKey: "lastName") as? String, let address = user.value(forKey: "address") as? String, let dob = user.value(forKey: "birthDate") as? Date, let imageData = user.value(forKey: "imageData") as? Data {
                        InternalHelper.sharedInstance.currentUser = CurrentUser(name: name, lastName: lastname, address: address, dob: dob, imageData: imageData)
                    }
                }
               return true
            }
            return false
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if usernameTextField.text != "" && passwordTextField.text != "" {
            attemptLogin(username: usernameTextField.text!, password: passwordTextField.text!)
        } else {
            displayAlert(title: "Campos vacíos", message: "Ingresa usuario y contraseña para iniciar sesión.")
        }
    }
    
}

extension LoginViewController: MKMapViewDelegate {
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
