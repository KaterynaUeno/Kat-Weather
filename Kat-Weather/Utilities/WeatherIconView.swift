//
//  WeatherIconView.swift
//  Kat-Weather
//
//  Created by Kateryna Ueno on 21/04/2026.
//


import SwiftUI

struct WeatherIconView: View {
    let iconCode: String?
    var size: CGFloat = 40

    private var url: URL? {
        guard let code = iconCode else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(code)@2x.png")
    }

    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        fallbackIcon
                    case .empty:
                        ProgressView()
                            .frame(width: size, height: size)
                    @unknown default:
                        fallbackIcon
                    }
                }
            } else {
                fallbackIcon
            }
        }
        .frame(width: size, height: size)
    }

    private var fallbackIcon: some View {
        Image(systemName: sfSymbol(for: iconCode))
            .resizable()
            .scaledToFit()
            .foregroundStyle(.secondary)
            .padding(6)
    }

    private func sfSymbol(for code: String?) -> String {
        guard let code else { return "cloud.fill" }
        switch code {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d", "10n": return "cloud.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snowflake"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}
