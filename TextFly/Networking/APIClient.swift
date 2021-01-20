//
//  APIClient.swift
//  TextFly
//
//  Created by Lucas Pereira on 19/01/21.
//

import Foundation
import Firebase
import Alamofire
import RxSwift

final class APIClient {
    private let successCode: Int = 200
    private static let forbiddenCode = [401]
    
    init() {
    }
    
    public class func requestSingle<T: Decodable>(_ route: RouterType, type: T.Type, isCancel: Bool = true) -> Observable<T> {
        return Observable.create { observer in
            let request = Session.default
                .request(route)
                .validate(contentType:["application/json", "json/text", "application/xml", "text/html"])
                .validate(statusCode: 200...209)
                .responseData { response in
                    self.reponseLog(response)
                    switch response.result {
                    case .success(let value):
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(T.self, from: value)
                            observer.onNext(result)
                            observer.onCompleted()
                        } catch {
                            // Error
                        }
                    case .failure(let error):
                        // Error
                        break
                    }
                }
            
            return Disposables.create(with: {
                if isCancel {
                    request.cancel()
                }
            })
        }
    }
    
    public class func requestList<T: Decodable>(_ route: RouterType, type: T.Type, isCancel: Bool = true) -> Observable<[T]> {
        return Observable.create { observer in
            let request = Session.default
                .request(route)
                .validate(contentType:["application/json", "json/text", "text/html"])
                .validate(statusCode: 200...209)
                .responseData { response in
                    reponseLog(response)
                    switch response.result {
                    case .success(let value):
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                            let result = try decoder.decode([T].self, from: value)
                            observer.onNext(result)
                            observer.onCompleted()
                        } catch {
                            // Error
                        }
                    case .failure(let error):
                        // Error
                        break
                    }
                }
            
            return Disposables.create(with: {
                if isCancel {
                    request.cancel()
                }
            })
        }
    }
    
    public class func reponseLog(_ response: AFDataResponse<Data>) {
        if let responseRequest = response.request, let body = responseRequest.httpBody,
           let sendParams = String(data: body, encoding: .utf8) {
            print("Request Parameters: \(sendParams)")
        }
        
        print("Request: \(String(describing: response.request))")
        print("Response: \(String(describing: response.response))")
        print("Error: \(String(describing: response.error))")
        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data Parsed: \(utf8Text)")
        }
    }
}

protocol RouterType: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var params: [String: Any]? { get }
    var encoding: ParameterEncoding { get }
    var contentType: String { get }
    var paramsQueryString: [String: Any]? { get }
}

extension RouterType {
    
    var hasAuthorization: Bool {
        return true
    }
    
    var encoding: ParameterEncoding {
        if paramsQueryString != nil {
            return URLEncoding.queryString
        }
        return JSONEncoding.default
    }
    
    var contentType: String {
        return "application/json"
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: path)!
        
        var urlRequest = try URLRequest(url: url, method: method)
        
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.timeoutInterval = 30.0
        if paramsQueryString != nil {
            urlRequest = try encoding.encode(urlRequest, with: paramsQueryString)
        }
        
        if method != .get, let params = params {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        return urlRequest
    }
}
