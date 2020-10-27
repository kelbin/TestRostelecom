//
//  SimpleNoteDateHelper.swift
//  TestRostelecom
//
//  Created by Савченко Максим Олегович on 2020. 01. 25..
//  Copyright © 2020. Савченко Максим Олегович. All rights reserved.
//

import Foundation

final class SimpleNoteDateHelper {
    
    static func convertDate(date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: date)
    
        let yourDate = formatter.date(from: myString)
      
        formatter.dateFormat = "EEEE, MMM d, yyyy, hh:mm:ss"
       
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
}

extension Date {
    func toSeconds() -> Int64! {
        return Int64((self.timeIntervalSince1970).rounded())
    }
    
    init(seconds:Int64!) {
        self = Date(timeIntervalSince1970: TimeInterval(Double.init(seconds)))
    }
}
