//
//  NotesRepository.swift
//  Notes
//
//  Created by Gopinath.A on 26/02/21.
//

import Foundation
import CoreData
import UIKit

protocol NotesRepository {
    func getNotes(completion: @escaping ([Note]) -> Void, error: @escaping (Error) -> ())
}

class NotesRepositoryImpl: NotesRepository {
    private let notesWebService: NotesWebSerice
    
    init(notesListService: NotesWebSerice = NotesWebSericeImpl()) {
        self.notesWebService = notesListService
    }
    
    
    func getNotes(completion: @escaping ([Note]) -> Void, error: @escaping (Error) -> ()) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        notesWebService.getNotes {[weak self] (notes) in
            
            if let notesFromDatabase = self?.saveNotes(context: context, notes: notes){
                completion(notesFromDatabase)
            }else{
                completion([])
            }
            
        } error: { (err) in
            error(err)
        }
    }
    
    private func saveNotes(context: NSManagedObjectContext, notes: [NotesModel]) -> [Note]{
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            var notesArray: [Note] = try context.fetch(request)
            notes.forEach { (noteFromWeb) in
                let hasItem = notesArray.contains(where: {$0.id == noteFromWeb.id})
                if !hasItem{
                    let newItem = Note(context: context)
                     newItem.id = noteFromWeb.id
                     newItem.body = noteFromWeb.body
                     newItem.image = noteFromWeb.image
                     newItem.title = noteFromWeb.title
                     newItem.time = noteFromWeb.time
                    notesArray.append(newItem)
                    try! context.save()
                }
            }
            return notesArray
        } catch  {
            print("Error in fetching request: \(error)")
        }
        return []
    }
}


