//
//  StationInfo.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

struct StationData: Codable {
    var trainsList: [StationTrain]

    enum CodingKeys: String, CodingKey {
        case trainsList = "objStationData"
    }
}

struct StationTrain: Codable {
    var trainCode: String
    var stationFullName: String
    var stationCode: String
    var trainDate: String
    var dueIn: Int
    var lateBy:Int
    var expArrival:String
    var expDeparture:String
    var destinationDetails:TrainMovement?

    enum CodingKeys: String, CodingKey {
        case trainCode = "Traincode"
        case stationFullName = "Stationfullname"
        case stationCode = "Stationcode"
        case trainDate = "Traindate"
        case dueIn = "Duein"
        case lateBy = "Late"
        case expArrival = "Exparrival"
        case expDeparture = "Expdepart"
    }

}

