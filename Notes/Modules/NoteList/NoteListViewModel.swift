//
//  NoteListViewModel.swift
//  Notes
//
//  Created by Gopinath.A on 26/02/21.
//

import Foundation

protocol NoteListViewModel {
    var notesCount: Int {get}
    func getNotes(completion: @escaping () -> Void)
    func note(at index: Int) -> Note
}

class NoteListViewModelImpl: NoteListViewModel {
    
    private let respository: NotesRepository
    private var notes: [Note] = []
    
    init(repository: NotesRepository = NotesRepositoryImpl()) {
        self.respository = repository
    }
    
    var notesCount: Int{
        notes.count
    }
    
    func note(at index: Int) -> Note {
        notes[index]
    }
    
    func getNotes(completion: @escaping () -> Void) {
        notes = []
        respository.getNotes(completion: { [weak self] notes in
            self?.notes = notes
            completion()
        }, error: { error in
            print(error);
            completion()
        })
    }
    
}
