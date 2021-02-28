//
//  CreateNoteRepository.swift
//  Notes
//
//  Created by Gopinath.A on 28/02/21.
//

import Foundation
import CoreData
import UIKit

protocol CreateNoteRepository {
    func createNote(note: CreateNoteModel, completion: @escaping (String) -> Void, error: @escaping (Error) -> ())
}

class CreateNoteRepositoryImpl: CreateNoteRepository {
    func createNote(note: CreateNoteModel, completion: @escaping (String) -> Void, error: @escaping (Error) -> ()) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newItem = Note(context: context)
        let id = UUID().uuidString
        newItem.id = id
        newItem.title = note.title
        newItem.body = note.body
        newItem.time = String(Date().timeIntervalSince1970)
        
        if let image = note.image{
            newItem.imageData = NoteImage(context: context)
            newItem.imageData?.data = image
            newItem.imageData?.id = id
            newItem.image = "Has Image"
        }
        
        do {
            try context.save()
            completion("Note Created")
        } catch let err {
            error(err)
        }
    }
}

