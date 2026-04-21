//
//  DateFormatters.swift
//  Kat-Weather
//
//  Created by Kateryna Ueno on 21/04/2026.
//


import Foundation

extension Date {
    var shortFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    var relativeFormatted: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
