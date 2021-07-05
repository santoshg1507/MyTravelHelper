//
//  AppConstants.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

let PROGRESS_INDICATOR_VIEW_TAG: Int = 10



struct URLConstants {
    
    static let baseURL = "http://api.irishrail.ie/realtime/realtime.asmx/"
    
    static let getAllStationsXML = baseURL + "getAllStationsXML"
    static let getStationDataByCodeXML_withParam = baseURL + "getStationDataByCodeXML?StationCode=%@"
    static let getTrainMovementsXML_withParam = baseURL + "getTrainMovementsXML?TrainId=%@&TrainDate=%@"
}
