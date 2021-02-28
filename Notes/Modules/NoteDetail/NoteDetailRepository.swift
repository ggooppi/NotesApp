//
//  NoteDetailRepository.swift
//  Notes
//
//  Created by Gopinath.A on 01/03/21.
//

import Foundation
import UIKit
import CoreData

protocol NoteDetailRepository {
    func downloadImage(id: String, imageURL: String, completion: @escaping (UIImage?) -> Void, error: @escaping (Error) -> ())
}

class NoteDetailRepositoryImpl: NoteDetailRepository {
    
    private let notesDetailWebService: NotesDetailWebSerice
    
    init(notesDetailService: NotesDetailWebSerice = NotesDetailWebSericeImpl()) {
        self.notesDetailWebService = notesDetailService
    }
    
    func downloadImage(id: String, imageURL: String, completion: @escaping (UIImage?) -> Void, error: @escaping (Error) -> ()) {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        notesDetailWebService.downloadImage(imageURL: imageURL) { (imageData) in
            
            request.predicate = NSPredicate(format: "id = %@", id as String)
            let notesArray: [Note] = try! context.fetch(request)
            let note = notesArray.first!
            note.imageData = NoteImage(context: context)
            note.imageData?.data = imageData
            note.imageData?.id = id
            try! context.save()
            completion(UIImage(data: imageData))
        } error: { (err) in
            request.predicate = NSPredicate(format: "id = %@", id as String)
            let notesArray: [Note] = try! context.fetch(request)
            let note = notesArray.first!
            note.image = ""
            try! context.save()
            error(err)
        }

    }
}
