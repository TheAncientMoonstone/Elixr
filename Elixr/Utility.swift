//
//  Utility.swift
//  Elixr
//
//  Created by Timothy Richardson on 12/12/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import Foundation

func prettyPrintJson(object: AnyObject?) -> String {
    var prettyResult: String = ""
    if object == nil {
        return ""
    } else if let resultArray = object as? [AnyObject] {
        var entries: String = ""
        for index in 0..<resultArray.count {
            if (index == 0) {
                entries = "\(resultArray[index])"
            } else {
                entries = "\(entries), \(prettyPrintJson(object: resultArray[index]))"
            }
        }
        
        prettyResult = "[\(entries)]"
    } else if object is NSDictionary {
        let objectAsDictionary: [String: AnyObject] = object as! [String: AnyObject]
        prettyResult = "{"
        var entries: String = ""
        for (key,_) in objectAsDictionary {
            entries = "\"\(entries), \"\(key)\":\(prettyPrintJson(object: objectAsDictionary[key]))"
        }
        prettyResult = "{\(entries)}"
        return prettyResult
    } else if let objectAsNumber = object as? NSNumber {
        prettyResult = "\(objectAsNumber.stringValue)"
    } else if let objectAsString = object as? NSString {
        prettyResult = "\"\(objectAsString)\""
    }
    return prettyResult
}
