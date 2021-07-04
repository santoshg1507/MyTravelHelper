//
//  DateFormatterExtension.swift
//  MyTravelHelper
//
//  Created by Santosh Gupta on 04/07/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation


@objc class SharedDateFormatter: DateFormatter {
    
    static var cache = NSCache<NSString, DateFormatter>()
    
    class func defaultDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        return dateFormatter
    }
    
    class func sharedDateFormatter(format:String) -> DateFormatter {
        
        if let cachedFormatter = cache.object(forKey: format as NSString) {
            return cachedFormatter
        }
        
        let newFormatter = defaultDateFormatter()
        newFormatter.dateFormat = format
        cache.setObject(newFormatter, forKey: format as NSString)
        
        return newFormatter
    }
    
}
