//
//  DateExtension.swift
//  MyTravelHelper
//
//  Created by Santosh Gupta on 04/07/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

extension Date {
    
    func string(withFormat format: String, locale: String, timeZone: TimeZone = TimeZone.current) -> String {
        let dateFormatter = SharedDateFormatter.sharedDateFormatter(format: format)
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
    
    func string(withFormat format: String, timeZone: TimeZone) -> String {
        let dateFormatter = SharedDateFormatter.sharedDateFormatter(format: format)
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
    
    func string(withFormat format: String) -> String {
        return self.string(withFormat: format, timeZone: TimeZone.current)
    }
    
    func addDays(_ daysToAdd: Int) -> Date {
        return self.addingTimeInterval(60 * 60 * 24 * Double(daysToAdd))
    }
}
