//
//  Stations.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

struct Stations: Codable {
    var stationsList: [Station]

    enum CodingKeys: String, CodingKey {
        case stationsList = "objStation"
    }
}

struct Station: Codable {
    var stationDesc: String
    var stationLatitude: Double
    var stationLongitude: Double
    var stationCode: String
    var stationId: Int16

    enum CodingKeys: String, CodingKey {
        case stationDesc = "StationDesc"
        case stationLatitude = "StationLatitude"
        case stationLongitude = "StationLongitude"
        case stationCode = "StationCode"
        case stationId = "StationId"
    }

}

