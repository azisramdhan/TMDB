//
//  DateFormatter.swift
//  TMDB
//
//  Created by Azis Ramdhan on 02/11/21.
//

import Foundation

extension DateFormatter {
    static let fromShortString: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static let date: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "MMMM dd, yyyy"
         return formatter
    }()

    static func string(iso string: String) -> String {
        guard let date = DateFormatter.fromShortString.date(from: string) else {
            return "There was an error decoding the string"
        }
        return  DateFormatter.date.string(from: date)
    }
}
