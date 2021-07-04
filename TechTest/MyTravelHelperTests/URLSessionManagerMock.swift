//
//  URLSessionManagerMock.swift
//  MyTravelHelperTests
//
//  Created by Santosh Gupta on 04/07/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation


class URLSessionManagerMock: URLSessionManagerProtocol {
    
    func api(url: String, method: HTTPMethod,  headers: [String:String]?, parameters: [String:Any]?, completion: @escaping((Int, Data?, Error?)->Void)) {
        
        if url == URLConstants.getAllStationsXML {
            let data = MockData.getAllStationsXMLString.data(using: .utf8)
            completion(200,data,nil )
        }
        else if url == URLConstants.getStationDataByCodeXML_withParam.addUrlParam(parameters: ["BFSTC"]) {
            let data = MockData.getStationDataByCodeXMLString.data(using: .utf8)
            completion(200,data,nil )
        }
        else if url == URLConstants.getTrainMovementsXML_withParam.addUrlParam(parameters: ["A141","04/07/2021"]) {
            let data = MockData.getTrainMovementsXMLString.data(using: .utf8)
            completion(200,data,nil )
        }
        
    }
    
    func getApi(url: String, completion: @escaping((Int, Data?, Error?)->Void)) {
        self.api(url: url, method: .get, headers: nil, parameters: nil) { (statusCode, data, error) in
            completion(statusCode,data,error)
        }
    }
    
}
