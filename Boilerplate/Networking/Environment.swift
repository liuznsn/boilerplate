//
//  Token.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/16.
//  Copyright © 2017年 Leo. All rights reserved.
//

import Foundation

struct Environment {
    
    var token: String? {
        get {
            return self.userDefaults.value(forKey: UserDefaultsKeys.Token.rawValue) as! String?
        }
        set {
            self.userDefaults.setValue(newValue, forKey: UserDefaultsKeys.Token.rawValue)
        }
    }
    
    var tokenExists: Bool {
        guard let _ = token else {
            return false
        }
        return true
    }
    
    func remove()  {
        self.userDefaults.dictionaryRepresentation().keys.forEach(self.userDefaults.removeObject(forKey:))
    }
    
    private let userDefaults: UserDefaults
    
    private enum UserDefaultsKeys: String {
        case Token = "user_auth_token"
        case Authorization = "user_auth"
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    init() {
        self.userDefaults = UserDefaults.standard
    }
}
