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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let username = usernameTextField.text, let password = passwordTextField.text {
            Alamofire.request("\(baseUrl)\(Endpoints.login.rawValue)").responseJSON { response in
                if let json = response.result.value as? [String: AnyObject] {
                    print("JSON: \(json)") // serialized json response
                    if let user = json["user"] as? String, let pass = json["password"] as? String {
                        if user == username && pass == password {
                            print("Continue")
                        } else {
                            print("Wrong")
                        }
                    }
                }
            }
        }
    }
    
}
