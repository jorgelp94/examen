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

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var map: MKMapView!
    
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1000
    var branches = [Branch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(location: initialLocation)
        downloadBranches()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func downloadBranches() {
        Alamofire.request("\(baseUrl)\(Endpoints.branches.rawValue)").responseJSON { response in
            let jsonDecoder = JSONDecoder()
            do {
                let results = try jsonDecoder.decode(Array<Branch>.self, from:response.data!)
                self.branches = results
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
                        print("Continue")
                    } else {
                        self.displayAlert(title: "Error", message: "Usuario y/o contraseña incorrectos. Intenta de nuevo.")
                    }
                }
            }
        }
    }
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if usernameTextField.text != "" && passwordTextField.text != "" {
            attemptLogin(username: usernameTextField.text!, password: passwordTextField.text!)
        } else {
            displayAlert(title: "Campos vacíos", message: "Ingresa usuario y contraseña para iniciar sesión.")
        }
    }
    
}
