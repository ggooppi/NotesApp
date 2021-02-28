//
//  Notes.swift
//  Notes
//
//  Created by Gopinath.A on 26/02/21.
//

import Foundation

struct NotesModel: Codable, Equatable {
    let id: String
    let title: String
    let body: String
    let time: String
    let image: String?
}
