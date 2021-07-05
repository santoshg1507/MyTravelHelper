//
//  StationName+CoreDataProperties.swift
//  
//
//  Created by Santosh Gupta on 05/07/21.
//
//

import Foundation
import CoreData


extension StationName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StationName> {
        return NSFetchRequest<StationName>(entityName: "StationName")
    }

    @NSManaged public var stationCode: String?
    @NSManaged public var stationDesc: String?
    @NSManaged public var stationId: Int16
    @NSManaged public var stationLatitude: Double
    @NSManaged public var stationLongitude: Double
    @NSManaged public var favorite: Bool

}





