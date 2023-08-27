//
//  DateUtilities.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-27.
//

import Foundation

class DateUtilities{
    
    static func getDate(for date: Date, given format: String = "dd-MMM-yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
