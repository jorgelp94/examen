//
//  Branch.swift
//  banregio
//
//  Created by Jorge Luis Perales on 5/19/18.
//  Copyright © 2018 Jorge Perales. All rights reserved.
//

import MapKit

class Branch: NSObject, Decodable {
    let id: String
    let type: String
    let name: String
    let address: String
    let schedule: String?
    let phonePortal: String?
    let phoneApp: String?
    let is24Hour: String
    let isOpenOnSaturday: String
    let city: String
    let state: String
    let managerEmail: String?
    let photoUrl: String?
    let branchPriorityState: String
    let branchPriorityCity: String
    let lat: String
    let long: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.type = try container.decode(String.self, forKey: .type)
        self.name = try container.decode(String.self, forKey: .name)
        self.address = try container.decode(String.self, forKey: .address)
        self.schedule = try container.decode(String?.self, forKey: .schedule)
        self.phonePortal = try container.decode(String?.self, forKey: .phonePortal)
        self.phoneApp = try container.decode(String?.self, forKey: .phoneApp)
        self.is24Hour = try container.decode(String.self, forKey: .is24Hour)
        self.isOpenOnSaturday = try container.decode(String.self, forKey: .isOpenOnSaturday)
        self.city = try container.decode(String.self, forKey: .city)
        self.state = try container.decode(String.self, forKey: .state)
        self.managerEmail = try container.decode(String?.self, forKey: .managerEmail)
        self.photoUrl = try container.decode(String?.self, forKey: .photoUrl)
        self.branchPriorityCity = try container.decode(String.self, forKey: .branchPriorityCity)
        self.branchPriorityState = try container.decode(String.self, forKey: .branchPriorityState)
        self.lat = try container.decode(String.self, forKey: .lat)
        self.long = try container.decode(String.self, forKey: .long)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "ID"
        case type = "tipo"
        case name = "NOMBRE"
        case address = "DOMICILIO"
        case schedule = "HORARIO"
        case phonePortal = "TELEFONO_PORTAL"
        case phoneApp = "TELEFONO_APP"
        case is24Hour = "24_HORAS"
        case isOpenOnSaturday = "SABADOS"
        case city = "CIUDAD"
        case state = "ESTADO"
        case managerEmail = "Correo_Gerente"
        case photoUrl = "URL_FOTO"
        case branchPriorityState = "Suc_Estado_Prioridad"
        case branchPriorityCity = "Suc_Ciudad_Prioridad"
        case lat = "Latitud"
        case long = "Longitud"
    }
}
