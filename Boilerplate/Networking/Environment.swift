//
//  Token.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/16.
//  Copyright © 2017年 Leo. All rights reserved.
//

import Foundation
import KeychainAccess
import RxSwift

struct Environment {
    
    static let shared = Environment()
    
    let keychainService = KeychainService(identifier: Bundle.main.bundleIdentifier!)
    
    var token: String? {
        get {
            return try! keychainService.get(forKey: KeychainKeys.Token.rawValue)
        }
        
        set {
            do {
                try keychainService.set(key: KeychainKeys.Token.rawValue, value: newValue!)
            }
            catch let error {
                print(error)
            }
        }
    }
    
    var tokenExists: Bool {
        guard let _ = token else {
            return false
        }
        return true
    }

    func isLogin() -> Observable<Bool>  {
        return Observable<Bool>.create({(observer) -> Disposable in
            guard let _ = try! self.keychainService.get(forKey: KeychainKeys.Token.rawValue) else {
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()
            }
             observer.onNext(true)
             observer.onCompleted()
            return Disposables.create()
        })
        
    }
    
    func remove()  {
        self.keychainService.remove()
    }
    
    private enum KeychainKeys: String {
        case Token = "user_auth_token"
        case Authorization = "user_auth"
    }
    
}


class KeychainService {
    private let keychain: Keychain
    init(identifier: String) {
        self.keychain = Keychain(service:identifier)
    }
    func set(key: String, value: String) throws {
        do {
            try keychain.set(value, key: key)
        }
        catch let error {
            print(error)
        }
    }
    func get(forKey: String) throws -> String? {
        
        let value = try? keychain.get(forKey)
        
        return value!
    }
    
    func remove() {
        try? keychain.removeAll()
    }
}

extension Reactive where Base: KeychainService {
    func set(key: String, value: String) -> Observable<Void> {
        
        return Observable<Void>.create({(observer) -> Disposable in
            do {
                try self.base.set(key: key, value: value)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            
            return Disposables.create()
        })
    }
    func get(forKey: String) -> Observable<String?> {
        return Observable<String?>.create({(observer) -> Disposable in
            do {
                let value = try self.base.get(forKey: forKey)
                observer.onNext(value)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            
            return Disposables.create()
        })
    }
}


