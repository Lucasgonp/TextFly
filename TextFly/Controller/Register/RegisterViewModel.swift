//
//  RegisterViewModel.swift
//  TextFly
//
//  Created by Lucas Pereira on 19/01/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol RegisterViewModelInput {
    func registerUser(inputs: [String:Any])
}

protocol RegisterViewModelOutput {
    var onRegisterUser: Driver<Void> { get }
    var isLoading: Driver<Bool> { get }
    var error: Driver<Error> { get }
}

protocol RegisterViewModelType {
    var input: RegisterViewModelInput { get }
    var output: RegisterViewModelOutput { get }
}

final class RegisterViewModel: RegisterViewModelType, RegisterViewModelInput, RegisterViewModelOutput {
    
    let onRegisterUser: SharedSequence<DriverSharingStrategy, Void>
    let isLoading: SharedSequence<DriverSharingStrategy, Bool>
    let error: SharedSequence<DriverSharingStrategy, Error>
    
    init(provider: UserDataProviderProtocol = UserDataProvider()) {
        
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker()
        
        error = errorTracker.asDriver()
        isLoading = activityTracker.asDriver()
        
        onRegisterUser = registerUserProperty.asDriverOnErrorJustComplete()
            .flatMapLatest({ (inputs) -> Driver<Void> in
                return provider.registerUser(inputs: inputs)
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            })
    }
    
    let registerUserProperty = PublishSubject<([String:Any])>()
    func registerUser(inputs: [String:Any]) {
        registerUserProperty.onNext((inputs))
    }
    
    var input: RegisterViewModelInput { return self }
    var output: RegisterViewModelOutput { return self }
}
