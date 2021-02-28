//
//  CreateNoteModel.swift
//  Notes
//
//  Created by Gopinath.A on 28/02/21.
//

import Foundation

struct CreateNoteModel: Codable, Equatable {
    let title: String
    let body: String
    let image: Data?
}
