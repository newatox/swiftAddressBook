//
//  UserDefaultsUtils.swift
//  AddressBookSwift4
//
//  Created by Arnaud on 26/10/2017.
//  Copyright © 2017 Arnaud. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func isFirstLaunch () -> Bool {
        return (UserDefaults.standard.value(forKey: "isFirstLaunch") as? Bool) ?? true
    }
    
    func userSawWelcomeMessage() {
        UserDefaults.standard.set(false, forKey: "isFirstLaunch")
    }
    
    func resetIsFirstLaunch() {
        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
    }
}
