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
    var profileObservable: Observable<[ProfileSectionModel]> { get }
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
       
        self.profileObservable = API.sharedAPI.profile()
            .trackActivity(Loading)
            .flatMap{ user -> Observable<[ProfileSectionModel]> in
                
                let profileSectionModel = ProfileSectionModel(model: "", items:
                    [Profile.avatar(title: "avatarUrl", avatarUrl: user.avatarUrl!)
                        ,Profile.detail(title: "id", detail: user.login!)
                    ]
                )
                
                return Observable.just([profileSectionModel])
            }
        
    }
    
    public var isLoading: Driver<Bool>
    public var profileObservable: Observable<[ProfileSectionModel]>
    public var inputs: ProfileViewModelInputs { return self}
    public var outputs: ProfileViewModelOutputs { return self}
}


