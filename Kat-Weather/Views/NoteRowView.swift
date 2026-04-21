//
//  NoteRowView.swift
//  Kat-Weather
//
//  Created by Kateryna Ueno on 21/04/2026.
//

import SwiftUI

struct NoteRowView: View {
    let note: Note

    var body: some View {
        HStack(spacing: 12) {
            // Weather icon
            WeatherIconView(iconCode: note.weather?.iconCode, size: 44)
                .background(
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 52, height: 52)
                )

            // Text info
            VStack(alignment: .leading, spacing: 4) {
                Text(note.text)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                Text(note.createdAt.shortFormatted)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
            if let weather = note.weather {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(weather.temperatureFormatted)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)

                    Text(weather.cityName)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            } else {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundStyle(.orange)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}


#Preview {
    List {
        NoteRowView(note: Note.mocks[0])
        NoteRowView(note: Note.mocks[1])
        NoteRowView(note: Note(text: "No weather note"))
    }
}
