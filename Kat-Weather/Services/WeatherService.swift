//
//  WeatherService.swift
//  Kat-Weather
//
//  Created by Kateryna Ueno on 21/04/2026.
//


import Foundation
import Network

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherData
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData
}

final class WeatherService: WeatherServiceProtocol {
    private let apiKey: String = "x"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let session: URLSession
    private let monitor = NWPathMonitor()
    private var isConnected = true

    init(session: URLSession = .shared) {
        self.session = session
        startNetworkMonitoring()
    }

    deinit {
        monitor.cancel()
    }


    func fetchWeather(for city: String) async throws -> WeatherData {
        try checkNetwork()
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "\(baseURL)?q=\(encodedCity)&appid=\(apiKey)"
        return try await fetch(urlString: urlString)
    }

    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData {
        try checkNetwork()
        let urlString = "\(baseURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        return try await fetch(urlString: urlString)
    }


    private func fetch(urlString: String) async throws -> WeatherData {
        guard let url = URL(string: urlString) else {
            throw AppError.invalidResponse
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(from: url)
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw AppError.networkUnavailable
            default:
                throw AppError.weatherFetchFailed(urlError.localizedDescription)
            }
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            break
        case 401:
            throw AppError.apiKeyMissing
        case 404:
            throw AppError.weatherFetchFailed("City not found")
        case 429:
            throw AppError.weatherFetchFailed("Too many requests. Please wait.")
        default:
            throw AppError.weatherFetchFailed("Server returned status \(httpResponse.statusCode)")
        }

        do {
            let dto = try JSONDecoder().decode(OpenWeatherDataResponse.self, from: data)
            guard let weatherData = dto.toWeatherData() else {
                throw AppError.decodingFailed
            }
            return weatherData
        } catch is DecodingError {
            throw AppError.decodingFailed
        }
    }

    private func checkNetwork() throws {
        guard isConnected else {
            throw AppError.networkUnavailable
        }
    }

    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
    }
}



final class MockWeatherService: WeatherServiceProtocol {
    var shouldFail = false
    var delay: UInt64 = 500_000_000 // 0.5s

    func fetchWeather(for city: String) async throws -> WeatherData {
        try await Task.sleep(nanoseconds: delay)
        if shouldFail { throw AppError.networkUnavailable }
        return .mock
    }

    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData {
        try await Task.sleep(nanoseconds: delay)
        if shouldFail { throw AppError.networkUnavailable }
        return .mock
    }
}


extension WeatherData {
    static let mock = WeatherData(
        temperature: 18.5,
        feelsLike: 17.0,
        description: "clear sky",
        iconCode: "01d",
        cityName: "Kyiv",
        humidity: 60,
        windSpeed: 3.5
    )
}
