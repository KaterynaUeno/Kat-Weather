//
//  WeatherData.swift
//  Kat-Weather
//
//  Created by Kateryna Ueno on 21/04/2026.
//


import Foundation


struct WeatherData: Codable, Equatable, Hashable  {
    let temperature: Double
    let feelsLike: Double
    let description: String
    let iconCode: String
    let cityName: String
    let humidity: Int
    let windSpeed: Double

    var iconURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
    }

    var temperatureFormatted: String {
        String(format: "%.0f°C", temperature)
    }

    var feelsLikeFormatted: String {
        String(format: "%.0f°C", feelsLike)
    }

    var descriptionCapitalized: String {
        description.prefix(1).uppercased() + description.dropFirst()
    }

    var windSpeedFormatted: String {
        String(format: "%.1f m/s", windSpeed)
    }

    var humidityFormatted: String {
        "\(humidity)%"
    }
}

        
struct OpenWeatherDataResponse: Codable, Hashable {
    let weather: [WeatherCondition]
    let main: MainWeatherInfo
    let wind: WindInfo
    let name: String

    struct WeatherCondition: Codable, Hashable {
        let description: String
        let icon: String
    }

    struct MainWeatherInfo: Codable, Hashable {
        let temp: Double
        let feelsLike: Double
        let humidity: Int

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case humidity
        }
    }

    struct WindInfo: Codable, Hashable {
        let speed: Double
    }

    func toWeatherData() -> WeatherData? {
        guard let condition = weather.first else { return nil }
        let tempCelsius = main.temp - 273.15
        let feelsLikeCelsius = main.feelsLike - 273.15
        return WeatherData(
            temperature: tempCelsius,
            feelsLike: feelsLikeCelsius,
            description: condition.description,
            iconCode: condition.icon,
            cityName: name,
            humidity: main.humidity,
            windSpeed: wind.speed
        )
    }
}
