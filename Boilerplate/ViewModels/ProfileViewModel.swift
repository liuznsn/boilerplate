//
//  ProfileViewModel.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/17.
//  Copyright © 2017年 Leo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

public protocol ProfileViewModelInputs {
    var isLoading: Driver<Bool> { get }

}

public protocol ProfileViewModelOutputs {
    var profileObservable: Driver<[ProfileSectionModel]> { get }
}

public protocol ProfileViewModelType {
    var inputs: ProfileViewModelInputs { get  }
    var outputs: ProfileViewModelOutputs { get }
}

public class ProfileViewModel: ProfileViewModelType, ProfileViewModelInputs, ProfileViewModelOutputs {
    
       private let disposeBag = DisposeBag()
    
    init() {
        
        let Loading = ActivityIndicator()
        self.isLoading = Loading.asDriver()

        self.profileObservable = Driver.empty()
        
        self.profileObservable = API.sharedAPI.profile()
            .trackActivity(Loading)
            .asDriver(onErrorJustReturn: User())
            .flatMap{ user -> Driver<[ProfileSectionModel]> in
                
                guard let _ = user.login else {
                    return Driver.just([])
                }
                
                let profileSectionModel = ProfileSectionModel(model: "", items:
                    [Profile.avatar(title: "avatarUrl", avatarUrl: user.avatarUrl!)
                    ,Profile.detail(title: "id", detail: user.login!)
                    ,Profile.detail(title: "createdAt", detail: user.createdAt!)]
                )
                
                return Driver.just([profileSectionModel])
            }
        
        
         let environment = Environment()
        
        
    }
    
    public var isLoading: Driver<Bool>
    public var profileObservable: Driver<[ProfileSectionModel]>
    public var inputs: ProfileViewModelInputs { return self}
    public var outputs: ProfileViewModelOutputs { return self}
}


