//
//  HomeModel.swift
//  Friend Contacts
//
//  Created by Shishir_Mac on 27/3/23.
//

import Foundation
import Contacts

class Friend {
    let firstName: String
    let lastName: String
    let workEmail: String
    var identifier: String?
    var storedContact: CNMutableContact?
    var phoneNumberField: (CNLabeledValue<CNPhoneNumber>)?
    
    init(firstName: String, lastName: String, workEmail: String){
        self.firstName = firstName
        self.lastName = lastName
        self.workEmail = workEmail
    }
}
