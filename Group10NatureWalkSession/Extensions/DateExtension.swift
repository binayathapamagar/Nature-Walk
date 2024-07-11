//
//  DateExtension.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-07-11.
//

import Foundation

extension Date {
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter
    }
    
    static func convertDateString(_ dateString: String) -> String {        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
            let formattedDate = outputFormatter.string(from: date)
            return formattedDate
        } else {
            return "Coming soon!"
        }
    }
    
}
