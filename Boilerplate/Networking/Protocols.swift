//
//  Protocols.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

public enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

public protocol GitHubAPI {
    func signin(_ username: String, password: String) -> Observable<Bool>
    func repositories(_ keyword:String, page:Int) -> Observable<[Repository]>
    func recentRepositories(_ language:String, page:Int) -> Observable<[Repository]>
    func profile() -> Observable<User>
}

public protocol GitHubValidationService {
    func validateEmail(_ email: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}
