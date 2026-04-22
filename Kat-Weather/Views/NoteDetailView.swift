//
//  NoteDetailView.swift
//  Kat-Weather
//
//  Created by Kateryna Ueno on 21/04/2026.
//


import SwiftUI

struct NoteDetailView: View {

    @StateObject private var viewModel: NoteDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(note: Note) {
        _viewModel = StateObject(wrappedValue: NoteDetailViewModel(note: note))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero header
                headerSection
                    .padding(.horizontal)
                    .padding(.top)

                Divider()
                    .padding(.vertical)

                    .padding(.horizontal)

                Spacer(minLength: 32)
            }
        }
        .navigationTitle("Note Detail")
        .navigationBarTitleDisplayMode(.inline)
    }


    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.note.text)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .fixedSize(horizontal: false, vertical: true)

                    Label(viewModel.formattedDate, systemImage: "calendar.badge.clock")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
    }


    @ViewBuilder
    private var weatherSection: some View {
        if viewModel.note.weather != nil {
            VStack(alignment: .leading, spacing: 16) {
                Label("Weather", systemImage: "cloud.sun.fill")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                // Main weather card
                mainWeatherCard

                // Details grid
                weatherDetailsGrid
            }
        } else {
            noWeatherView
        }
    }

    private var mainWeatherCard: some View {
        HStack(spacing: 16) {
            WeatherIconView(iconCode: viewModel.note.weather?.iconCode, size: 72)

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.temperature)
                    .font(.system(size: 48, weight: .thin))

                Text(viewModel.weatherDescription)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Label(viewModel.cityName, systemImage: "location.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }

    private var weatherDetailsGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 12
        ) {
            WeatherDetailCell(
                icon: "thermometer.medium",
                label: "Feels Like",
                value: viewModel.feelsLike
            )
            WeatherDetailCell(
                icon: "humidity.fill",
                label: "Humidity",
                value: viewModel.humidity
            )
            WeatherDetailCell(
                icon: "wind",
                label: "Wind Speed",
                value: viewModel.windSpeed
            )
            WeatherDetailCell(
                icon: "location.fill",
                label: "Location",
                value: viewModel.cityName
            )
        }
    }

    private var noWeatherView: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
                .font(.title2)

            VStack(alignment: .leading, spacing: 4) {
                Text("Weather unavailable")
                    .font(.headline)
                Text("Could not retrieve weather data for this note.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}


private struct WeatherDetailCell: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}



#Preview {
    NavigationStack {
        NoteDetailView(note: Note.mocks[0])
    }
}
