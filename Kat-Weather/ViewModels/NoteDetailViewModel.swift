//
//  NoteDetailViewModel.swift
//  Kat-Weather
//
//  Created by Kateryna Ueno on 21/04/2026.
//


import Foundation
import Combine

@MainActor
final class NoteDetailViewModel: ObservableObject {


    @Published private(set) var note: Note

    var formattedDate: String {
        note.createdAt.formatted(date: .long, time: .shortened)
    }

    var weatherDescription: String {
        note.weather?.descriptionCapitalized ?? "Weather unavailable"
    }

    var temperature: String {
        note.weather?.temperatureFormatted ?? "–"
    }

    var feelsLike: String {
        note.weather?.feelsLikeFormatted ?? "–"
    }

    var humidity: String {
        note.weather?.humidityFormatted ?? "–"
    }

    var windSpeed: String {
        note.weather?.windSpeedFormatted ?? "–"
    }

    var cityName: String {
        note.weather?.cityName ?? "Unknown location"
    }

    var weatherIconURL: URL? {
        note.weather?.iconURL
    }


    init(note: Note) {
        self.note = note
    }
}
