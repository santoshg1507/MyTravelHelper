//
//  URLSessionManager.swift
//  MyTravelHelper
//
//  Created by Santosh Gupta on 04/07/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

enum NetworkError: Error, LocalizedError {
    case urlError
    case invalidData
    case decodingFailed
    case otherError(String)
}

protocol URLSessionManagerProtocol {
    func api(url: String, method: HTTPMethod,  headers: [String:String]?, parameters: [String:Any]?, completion: @escaping((Int, Data?, Error?)->Void))
    func getApi(url: String, completion: @escaping((Int, Data?, Error?)->Void))
    func api(request: URLRequestConvertible, completion: @escaping((Int, Data?, Error?)->Void))
}

class URLSessionManager: URLSessionManagerProtocol {
    
    let session = URLSession.shared

    func api(url: String, method: HTTPMethod,  headers: [String:String]? = nil, parameters: [String:Any]? = nil, completion: @escaping((Int, Data?, Error?)->Void)) {
        guard let url = URL(string: url) else { completion(600, nil, NetworkError.urlError); return }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        var data: Data?
        if let parameters = parameters {
            data = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        request.httpBody = data
        let task = session.dataTask(with: request) { data, response, error in
            completion((response as? HTTPURLResponse)?.statusCode ?? 600 , data,error)
        }
        
        task.resume()
    }
    
    func getApi(url: String, completion: @escaping((Int, Data?, Error?)->Void)) {
        self.api(url: url, method: .get, headers: nil, parameters: nil) { (statusCode, data, error) in
            completion(statusCode, data,error)
        }
    }
    
    func api(request: URLRequestConvertible, completion: @escaping((Int, Data?, Error?)->Void)) {
        let urlRequest = request.asURLRequest()
        let task = session.dataTask(with: urlRequest) { data, response, error in
            completion((response as? HTTPURLResponse)?.statusCode ?? 600 , data,error)
        }
        task.resume()
    }
   
}
