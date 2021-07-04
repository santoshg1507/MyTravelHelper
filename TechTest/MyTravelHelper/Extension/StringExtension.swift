//
//  StringExtension.swift
//  MyTravelHelper
//
//  Created by Santosh Gupta on 04/07/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

extension String {
    func addUrlParam(parameters: [String]) -> String {
        let str = String(format: self, arguments: parameters)
        return str
    }
    
    func localized(withComment:String) -> String {
        return NSLocalizedString(self, comment: withComment)
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(parameters: [String]) -> String {
        let str = String(format: self.localized(), arguments: parameters)
        return str
    }
}


extension NSObject {
    static var className : String {
        return String(describing:self)
    }
}
