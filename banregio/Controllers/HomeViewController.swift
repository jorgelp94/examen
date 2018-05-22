//
//  HomeViewController.swift
//  banregio
//
//  Created by Jorge Luis Perales on 5/21/18.
//  Copyright © 2018 Jorge Perales. All rights reserved.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {

    @IBOutlet weak var animationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBarStyle()
        
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
        self.navigationController?.navigationBar.barTintColor = ColorPalette.orange
        self.navigationItem.title = "Home"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white, NSAttributedStringKey.font: UIFont(name: "CircularStd-Book", size: 20)!]
    }
    
}
