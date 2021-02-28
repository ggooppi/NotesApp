//
//  NoteDetailWebService.swift
//  Notes
//
//  Created by Gopinath.A on 28/02/21.
//

import Foundation

protocol NotesDetailWebSerice {
    func downloadImage(imageURL: String, completion:@escaping (Data) -> Void, error: @escaping (Error) -> ())
}

class NotesDetailWebSericeImpl: NotesDetailWebSerice {
    
    private let networkClient: NetworkClient
    private let decoder: JSONDecoder
    
    private var downloadTask: URLSessionTask?
    
    init(networkClient: NetworkClient = NetworkClientImpl(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.networkClient = networkClient
        self.decoder = decoder
    }
    
    func downloadImage(imageURL: String, completion: @escaping (Data) -> Void, error: @escaping (Error) -> ()) {
        guard let url = urlFromString(imageURL) else {
            error(NSError.init(error: "Note able to create URL"))
            return
        }
    
        cancelOngoingDownload()
        
        let downloadTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data ?? Data())
        }

        downloadTask.resume()
        
        self.downloadTask = downloadTask
    }
    
    private func urlFromString(_ url: String) -> URL? {
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return nil
        }
        guard let url = URL(string: encodedUrl) else {
            return nil
        }
        return url
    }
    
    private func cancelOngoingDownload() {
        if let downloadTask = self.downloadTask, downloadTask.state != URLSessionTask.State.completed  {
            downloadTask.cancel()
        }
    }
}
