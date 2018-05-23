//
//  HomeViewController.swift
//  banregio
//
//  Created by Jorge Luis Perales on 5/21/18.
//  Copyright © 2018 Jorge Perales. All rights reserved.
//

import UIKit
import Lottie
import SlideMenuControllerSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var animationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBarStyle()
        showAnimation()
        
        self.welcomeLabel.text = "Bienvenido a tu Home \(InternalHelper.sharedInstance.currentUser.name)"
    }
    
    func showAnimation() {
        let animation = LOTAnimationView(name: "atm_")
        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        animation.contentMode = .scaleAspectFill
        animation.frame = self.animationView.bounds
        self.animationView.addSubview(animation)
        animation.play{ (finished) in
            // Do Something
            print("finished")
        }
    }

    func setupNavBarStyle() {
        self.navigationItem.title = "Home"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white, NSAttributedStringKey.font: UIFont(name: "CircularStd-Book", size: 20)!]
    }
    
    @IBAction func openMenuButtonPressed(_ sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }
    
}
