//
//  NoteListViewModel.swift
//  Kat-Weather
//
//  Created by Kateryna Ueno on 21/04/2026.
//

import Foundation
import Combine

@MainActor
final class NoteListViewModel: ObservableObject {

    @Published private(set) var notes: [Note] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let storage: NoteStorageServiceProtocol



    init(storage: NoteStorageServiceProtocol = UserDefaultsNoteStorage()) {
        self.storage = storage
        loadNotes()
    }

    func loadNotes() {
        do {
            notes = try storage.loadNotes()
                .sorted { $0.createdAt > $1.createdAt }
        } catch {
            errorMessage = (error as? AppError)?.errorDescription ?? error.localizedDescription
        }
    }

    func delete(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        persistNotes()
    }

    func delete(note: Note) {
        notes.removeAll { $0.id == note.id }
        persistNotes()
    }

    func addNote(_ note: Note) {
        notes.insert(note, at: 0)
        persistNotes()
    }

    func dismissError() {
        errorMessage = nil
    }


    private func persistNotes() {
        do {
            try storage.save(notes: notes)
        } catch {
            errorMessage = (error as? AppError)?.errorDescription ?? error.localizedDescription
        }
    }
}
