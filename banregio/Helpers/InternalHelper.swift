//
//  InternalHelper.swift
//  banregio
//
//  Created by Jorge Luis Perales on 5/22/18.
//  Copyright © 2018 Jorge Perales. All rights reserved.
//

import Foundation

struct CurrentUser {
    var name: String
    var lastName: String
    var address: String
    var dob: Date
    var imageData: Data?
}

class InternalHelper {
    var currentUser = CurrentUser(name: "", lastName: "", address: "", dob: Date(), imageData: nil)
    var branches = [Branch]()
    static let sharedInstance: InternalHelper = InternalHelper()
    
}
