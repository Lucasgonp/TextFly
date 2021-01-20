//
//  UserRoute.swift
//  TextFly
//
//  Created by Lucas Pereira on 19/01/21.
//

import Foundation
import Alamofire

enum UserRoute {
    case registerUser(inputs: [String:Any])
}

extension UserRoute: RouterType {
    
    var path: String {
        switch self {
        case .registerUser:
            return "v2/customers"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .registerUser:
            return .post
        }
    }
    
    var paramsQueryString: [String : Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    var params: [String: Any]? {
        switch self {
        case .registerUser(let inputs):
            var params: [String:Any] = [:]
            for input in inputs {
                params[input.key] = input.value
            }
            return params
        }
    }
    
}
