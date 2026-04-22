//
//  AddNoteViewModel.swift
//  Kat-Weather
//
//  Created by Kateryna Ueno on 21/04/2026.
//


import Foundation
import Combine

enum AddNoteState: Equatable {
    case idle
    case fetchingWeather
    case success(Note)
    case failure(AppError)
}

@MainActor
final class AddNoteViewModel: ObservableObject {


    @Published var noteText: String = ""
    @Published private(set) var state: AddNoteState = .idle

    var isSaveDisabled: Bool {
        noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || state == .fetchingWeather
    }


    private let weatherService: WeatherServiceProtocol
    private let city: String


    init(
        weatherService: WeatherServiceProtocol? = nil,
        city: String = "Kyiv"
    ) {
        self.weatherService = weatherService ?? WeatherService()
        self.city = city
    }



    func saveNote() {
        let trimmed = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        state = .fetchingWeather

        Task {
            do {
                let weather = try await weatherService.fetchWeather(for: city)
                let note = Note(text: trimmed, createdAt: Date(), weather: weather)
                state = .success(note)
            } catch let appError as AppError {
                state = .failure(appError)
            } catch {
                state = .failure(.unknown)
            }
        }
    }

    func reset() {
        noteText = ""
        state = .idle
    }

    func dismissError() {
        state = .idle
    }
}
