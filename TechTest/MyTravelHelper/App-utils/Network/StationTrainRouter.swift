//
//  StationTrainRouter.swift
//  MyTravelHelper
//
//  Created by Santosh Gupta on 06/07/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

protocol URLRequestConvertible {
    
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var url: URL { get }
    
}

extension URLRequestConvertible {
    
    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: self.url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        if let parameters = parameters {
            let data = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = data
        }
        return request
    }
    
}

enum StationTrainRouter: URLRequestConvertible {
    
    case getAllStations
    case getStationDataByCode(stationCode: String)
    case getTrainMovements(trainId: String, trainDate: String)

    var method: HTTPMethod {
        switch self {
        case .getAllStations, .getStationDataByCode, .getTrainMovements:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAllStations, .getStationDataByCode, .getTrainMovements:
            return nil
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getAllStations, .getStationDataByCode, .getTrainMovements:
            return nil
        }
    }
    
    var pathParameters: [String: Any]? {
        switch self {
        case .getAllStations:
            return nil
        case .getStationDataByCode(let stationCode):
            return [
                "StationCode": stationCode
            ]
        case .getTrainMovements(let trainId, let trainDate):
            return [
                "TrainId": trainId,
                "TrainDate": trainDate
            ]
        }
    }
    
    var url: URL {
        let endpoint: String
        switch self {
        case .getAllStations:
            endpoint = URLConstants.getAllStationsXML
        case .getStationDataByCode(let stationCode):
            endpoint = URLConstants.getStationDataByCodeXML_withParam.addUrlParam(parameters: [stationCode])
        case .getTrainMovements(let trainId, let trainDate):
            endpoint = URLConstants.getTrainMovementsXML_withParam.addUrlParam(parameters: [trainId,trainDate])
        }
        return URL(string: endpoint)!
    }

}
