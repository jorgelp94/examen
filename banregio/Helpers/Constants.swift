//
//  Constants.swift
//  banregio
//
//  Created by Jorge Luis Perales on 5/16/18.
//  Copyright © 2018 Jorge Perales. All rights reserved.
//

import UIKit

// MARK: Endpoints
enum Endpoints: String {
    case login = "login"
    case branches = "sucursales"
}
let baseUrl = "http://json.banregio.io/"

// MARK: Colors
enum ColorPalette {
    static let orange = UIColor(red: 255/255, green: 103/255, blue: 27/255, alpha: 1)
}
