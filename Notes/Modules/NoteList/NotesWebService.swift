//
//  NotesWebService.swift
//  Notes
//
//  Created by Gopinath.A on 26/02/21.
//

import Foundation

protocol NotesWebSerice {
    func getNotes(completion:@escaping ([NotesModel]) -> Void, error: @escaping (Error) -> ())
}

class NotesWebSericeImpl: NotesWebSerice {
    private let networkClient: NetworkClient
    private let decoder: JSONDecoder
    
    init(networkClient: NetworkClient = NetworkClientImpl(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.networkClient = networkClient
        self.decoder = decoder
    }

    func getNotes(completion: @escaping ([NotesModel]) -> Void, error: @escaping (Error) -> ()) {
        let httpRequest = HttpRequest(method: .GET,
                                      url:"https://raw.githubusercontent.com/RishabhRaghunath/JustATest/master/posts",//"http://192.168.1.3:8887/posts.txt",//"https://raw.githubusercontent.com/RishabhRaghunath/JustATest/master/posts",
                                      body: nil,
                                      headers: nil)
        
        networkClient.performRequest(httpRequest) { httpResult in
            switch httpResult {
            case .failure(let err):
                error(err)
            case .success(let data):
                guard let products = self.parseNotesResponse(data: data) else {
                    error(NSError(error: "Parsing Error"))
                    return
                }
                completion(products)
            }
        }
    }
    
    private func parseNotesResponse(data: Data) -> [NotesModel]? {
        do {
            return try decoder.decode([NotesModel].self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
