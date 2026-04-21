//
//  AddNoteView.swift
//  Kat-Weather
//
//  Created by Kateryna Ueno on 21/04/2026.
//


import SwiftUI

struct AddNoteView: View {

    @StateObject private var viewModel = AddNoteViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool

    var onSave: (Note) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        "What are you doing?",
                        text: $viewModel.noteText,
                        axis: .vertical
                    )
                    .lineLimit(3...8)
                    .focused($isTextFieldFocused)
                    .disabled(viewModel.state == .fetchingWeather)
                } header: {
                    Text("Note")
                } footer: {
                    Text("Weather for Kyiv will be automatically attached.")
                        .font(.caption)
                }

                Section {
                    stateView
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(viewModel.state == .fetchingWeather)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        isTextFieldFocused = false
                        viewModel.saveNote()
                    }
                    .fontWeight(.semibold)
                    .disabled(viewModel.isSaveDisabled)
                }
            }
            .onChange(of: viewModel.state) { _, newState in
                handleStateChange(newState)
            }
            .onAppear {
                isTextFieldFocused = true
            }
        }
    }


    @ViewBuilder
    private var stateView: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()

        case .fetchingWeather:
            HStack(spacing: 12) {
                ProgressView()
                    .progressViewStyle(.circular)
                Text("Fetching weather...")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            .padding(.vertical, 4)

        case .success(let note):
            if let weather = note.weather {
                WeatherPreviewRow(weather: weather)
            }

        case .failure(let error):
            VStack(alignment: .leading, spacing: 6) {
                Label(error.errorDescription ?? "Unknown error", systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.subheadline)

                if let suggestion = error.recoverySuggestion {
                    Text(suggestion)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Button("Try Again") {
                    viewModel.saveNote()
                }
                .font(.subheadline)
                .buttonStyle(.borderless)
                .tint(.accentColor)
                .padding(.top, 2)
            }
            .padding(.vertical, 4)
        }
    }


    private func handleStateChange(_ state: AddNoteState) {
        if case .success(let note) = state {
            onSave(note)
            dismiss()
        }
    }
}



private struct WeatherPreviewRow: View {
    let weather: WeatherData

    var body: some View {
        HStack(spacing: 10) {
            WeatherIconView(iconCode: weather.iconCode, size: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(weather.temperatureFormatted) · \(weather.descriptionCapitalized)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(weather.cityName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        }
        .padding(.vertical, 2)
    }
}


#Preview {
    AddNoteView { _ in }
}
