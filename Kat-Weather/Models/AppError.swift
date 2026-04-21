//
//  AppError.swift
//  Kat-Weather
//
//  Created by Kateryna Ueno on 21/04/2026.
//


import Foundation

enum AppError: LocalizedError, Equatable {
    case networkUnavailable
    case invalidResponse
    case decodingFailed
    case apiKeyMissing
    case weatherFetchFailed(String)
    case storageFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "No internet connection. Please check your network and try again."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .decodingFailed:
            return "Failed to process the weather data."
        case .apiKeyMissing:
            return "Weather API key is not configured."
        case .weatherFetchFailed(let message):
            return "Failed to fetch weather: \(message)"
        case .storageFailed:
            return "Failed to save note. Please try again."
        case .unknown:
            return "An unexpected error occurred."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .networkUnavailable:
            return "Check your Wi-Fi or cellular connection."
        case .apiKeyMissing:
            return "Add your OpenWeather API key to Config.plist."
        default:
            return "Please try again later."
        }
    }
}
