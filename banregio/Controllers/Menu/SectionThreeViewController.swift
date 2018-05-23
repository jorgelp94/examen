//
//  SectionThreeViewController.swift
//  banregio
//
//  Created by Jorge Luis Perales on 5/21/18.
//  Copyright © 2018 Jorge Perales. All rights reserved.
//

import UIKit

class SectionThreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.backgroundColor = ColorPalette.orange
        self.navigationController?.navigationBar.barTintColor = ColorPalette.orange
        self.navigationItem.title = "Sección 3"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white, NSAttributedStringKey.font: UIFont(name: "CircularStd-Book", size: 20)!]
    }

    @IBAction func openMenuButtonPressed(_ sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }
    

}
