//
//  TrainMovements.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

struct TrainMovementsData: Codable {
    var trainMovements: [TrainMovement]

    enum CodingKeys: String, CodingKey {
        case trainMovements = "objTrainMovements"
    }
}

struct TrainMovement: Codable {
    var trainCode: String
    var locationCode: String
    var locationFullName: String? //making optional because of data not coming in some object
    var expDeparture:String

    enum CodingKeys: String, CodingKey {
        case trainCode = "TrainCode"
        case locationCode = "LocationCode"
        case locationFullName = "LocationFullName"
        case expDeparture = "ExpectedDeparture"
    }

}

