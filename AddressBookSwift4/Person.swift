//
//  Person.swift
//  AddressBookSwift4
//
//  Created by Arnaud on 26/10/2017.
//  Copyright © 2017 Arnaud. All rights reserved.
//

import Foundation

extension Person {
    var firstLetter: String {
        if let first = lastName?.characters.first {
            return String(first)
        } else {
            return "?"
        }
    }
}


