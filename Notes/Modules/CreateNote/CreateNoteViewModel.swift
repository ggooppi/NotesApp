//
//  CreateNoteViewModel.swift
//  Notes
//
//  Created by Gopinath.A on 28/02/21.
//

import Foundation

protocol CreateNoteViewModel {
    func saveImage(imageData: Data)
    func saveNote(title: String, body: String, completion: @escaping () -> Void)
}

class CreateNoteViewModelImpl: CreateNoteViewModel {
    
    private let respository: CreateNoteRepository
    private var imageData: Data? = nil
    
    init(repository: CreateNoteRepository = CreateNoteRepositoryImpl()) {
        self.respository = repository
    }
    
    func saveNote(title: String, body: String, completion: @escaping () -> Void) {
        let note = CreateNoteModel(title: title, body: body, image: imageData)
        respository.createNote(note: note) { (Message) in
            print(Message)
            completion()
        } error: { (error) in
            print(error)
        }

    }
    
    func saveImage(imageData: Data) {
        self.imageData = imageData
    }
}
