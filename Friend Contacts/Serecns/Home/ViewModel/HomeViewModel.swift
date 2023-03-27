//
//  HomeViewModel.swift
//  Friend Contacts
//
//  Created by Shishir_Mac on 27/3/23.
//

import Foundation
import UIKit
import Contacts

extension Friend: Equatable {
    static func ==(lhs: Friend, rhs: Friend) -> Bool{
        return lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.workEmail == rhs.workEmail
    }
}

extension Friend {
    var contactValue: CNContact {
        let contact = CNMutableContact()
        contact.givenName = firstName
        contact.familyName = lastName
        contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: workEmail as NSString)]
        
        if let phoneNumberField = phoneNumberField {
            contact.phoneNumbers.append(phoneNumberField)
        }
        return contact.copy() as! CNContact
    }
    
    convenience init?(contact: CNContact) {
        guard let email = contact.emailAddresses.first else { return nil }
        let firstName = contact.givenName
        let lastName = contact.familyName
        let workEmail = email.value as String
        
        self.init(firstName: firstName, lastName: lastName, workEmail: workEmail)
        if let contactPhone = contact.phoneNumbers.first {
            phoneNumberField = contactPhone
        }
    }
}
