//
//  RegisterViewController.swift
//  banregio
//
//  Created by Jorge Luis Perales on 5/20/18.
//  Copyright © 2018 Jorge Perales. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = ColorPalette.orange
        self.navigationItem.title = "Alta de Usuario"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white, NSAttributedStringKey.font: UIFont(name: "CircularStd-Book", size: 20)!]
    }

    @IBAction func addImageButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func saveFormButtonPressed(_ sender: UIButton) {
    }
}
