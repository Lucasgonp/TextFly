//
//  UserDataProvider.swift
//  TextFly
//
//  Created by Lucas Pereira on 19/01/21.
//

import RxSwift
import Firebase

protocol UserDataProviderProtocol: class {
    //func doLogout() -> Observable<Void>
    func registerUser(inputs: [String:Any]) -> Observable<Void>
//    func doLogin(email: String, password: String) -> Observable<EmptyEntity>
}

class UserDataProvider: UserDataProviderProtocol {
    var auth: Auth = Auth.auth()
    
    func registerUser(inputs: [String : Any]) -> Observable<Void> {
        var email: String = ""
        var password: String = ""
        for input in inputs {
            if input.key == "email" {
                email = "\(input.value)"
            }
            if input.key == "password" {
                password = "\(input.value)"
            }
        }
        return Observable.just(auth.createUser(withEmail: email, password: password, completion: { (result, error) in
            if error == nil {
                
            }
            
        }))
        
//        return APIClient.requestSingle(UserRoute.registerUser(inputs: inputs), type: EmptyEntity.self)
    }
    
//    func doLogout() -> Observable<Void> {
//        <#code#>
//    }
    
//    func doLogin(email: String, password: String) -> Observable<EmptyEntity> {
//        <#code#>
//    }
}
