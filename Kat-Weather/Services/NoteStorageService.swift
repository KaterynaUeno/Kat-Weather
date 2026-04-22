//
//  NoteStorage.swift
//  Kat-Weather
//
//  Created by Kateryna Ueno on 21/04/2026.
//


import Foundation


protocol NoteStorageServiceProtocol {
    func loadNotes() throws -> [Note]
    func save(notes: [Note]) throws
}



final class UserDefaultsNoteStorage: NoteStorageServiceProtocol {

    private let key = "weathernotes.stored_notes"
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func loadNotes() throws -> [Note] {
        guard let data = defaults.data(forKey: key) else {
            return []
        }
        do {
            return try decoder.decode([Note].self, from: data)
        } catch {
            throw AppError.storageFailed
        }
    }

    func save(notes: [Note]) throws {
        do {
            let data = try encoder.encode(notes)
            defaults.set(data, forKey: key)
        } catch {
            throw AppError.storageFailed
        }
    }
}



final class InMemoryNoteStorage: NoteStorageServiceProtocol {
    private var store: [Note] = Note.mocks

    func loadNotes() throws -> [Note] { store }

    func save(notes: [Note]) throws { store = notes }
}



extension Note {
    static let mocks: [Note] = [
        Note(
            id: UUID(),
            text: "Morning run in the park",
            createdAt: Date().addingTimeInterval(-86400),
            weather: .mock
        ),
        Note(
            id: UUID(),
            text: "Drive to office",
            createdAt: Date().addingTimeInterval(-3600),
            weather: WeatherData(
                temperature: 12.0,
                feelsLike: 10.5,
                description: "overcast clouds",
                iconCode: "04d",
                cityName: "Kyiv",
                humidity: 80,
                windSpeed: 5.2
            )
        )
    ]
}
