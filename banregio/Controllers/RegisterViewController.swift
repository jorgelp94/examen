//
//  RegisterViewController.swift
//  banregio
//
//  Created by Jorge Luis Perales on 5/20/18.
//  Copyright © 2018 Jorge Perales. All rights reserved.
//

import UIKit
import CoreData
import SlideMenuControllerSwift

class RegisterViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    let picker = UIImagePickerController()
    var datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarStyle()
        picker.delegate = self
        setupDatePicker()
        setupDateFormatter()
    }
    
    func setupNavBarStyle() {
        self.navigationItem.title = "Alta de Usuario"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white, NSAttributedStringKey.font: UIFont(name: "CircularStd-Book", size: 20)!]
    }
    
    func setupDateFormatter() {
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = "dd-MM-yyyy"
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(datePicker:)), for: .valueChanged)
        birthDateTextField.inputView = datePicker
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func save(name: String, lastName: String, dob: Date, address: String, photoData: Data?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "User",
                                                in: managedContext)!
        let user = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        user.setValue(name, forKeyPath: "name")
        user.setValue(lastName, forKey: "lastName")
        user.setValue(dob, forKey: "birthDate")
        user.setValue(address, forKey: "address")
        if let photoData = photoData {
            user.setValue(photoData, forKey: "imageData")
        }
        
        do {
            try managedContext.save()
            self.displayAlert(title: "Éxito", message: "La información de tu perfil se guardó exitosamente.")
            self.presentMainMenu()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func presentMainMenu() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeNavigationViewController")
        let leftViewController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController")
        let slideMenuController = SlideMenuController(mainViewController: homeViewController!, leftMenuViewController: leftViewController!)
        UIApplication.shared.keyWindow?.rootViewController = slideMenuController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
        self.birthDateTextField.text = dateFormatter.string(from: datePicker.date)
    }

    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveFormButtonPressed(_ sender: UIButton) {
        self.addressTextField.resignFirstResponder()
        if nameTextField.text != "" && lastnameTextField.text != "" && birthDateTextField.text != "" && addressTextField.text != "" {
            let date = dateFormatter.date(from: birthDateTextField.text!)
            let image: Data = UIImageJPEGRepresentation(self.profileImageView.image!, 0.7)!
            self.save(name: nameTextField.text!, lastName: lastnameTextField.text!, dob: date!, address: addressTextField.text!, photoData: image)
        } else {
            self.displayAlert(title: "Error", message: "Por favor completa todos los campos para guardar.")
        }
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = chosenImage
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2
        profileImageView.clipsToBounds = true
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
