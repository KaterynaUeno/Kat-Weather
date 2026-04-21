//
//  Note.swift
//  Kat-Weather
//
//  Created by Kateryna Ueno on 21/04/2026.
//

// Models/Note.swift

import Foundation

struct Note: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    let createdAt: Date
    var weather: WeatherData?

    init(id: UUID = UUID(), text: String, createdAt: Date = Date(), weather: WeatherData? = nil) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.weather = weather
    }

    static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.id == rhs.id
    }
}
