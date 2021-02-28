//
//  NetworkClient.swift
//  Notes
//
//  Created by Gopinath.A on 26/02/21.
//

import Foundation

protocol NetworkClient {
    func performRequest(_ request: HttpRequest, completion: @escaping (HttpResult) -> Void)
}

class NetworkClientImpl: NetworkClient {
    
    private let urlSession: URLSession
    private let httpRequestMapper: HttpRequestMapper
    
    init(urlSession: URLSession = URLSession.shared,
         httpRequestMapper: HttpRequestMapper = HttpRequestMapperImpl()) {
        self.urlSession = urlSession
        self.httpRequestMapper = httpRequestMapper
    }
    
    func performRequest(_ httpRequest: HttpRequest,
                        completion: @escaping (HttpResult) -> Void) {
        guard let request = httpRequestMapper.map(httpRequest: httpRequest) else {
            return
        }

        let task = urlSession.dataTask(with: request) { (data, response, error) in
            let result = self.handleResponse(data: data, response: response, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    private func handleResponse(data: Data?,
                                response: URLResponse?,
                                error: Error?) -> HttpResult {
        guard let dataResponse = data, error == nil else {
            return HttpResult.failure(NSError(error: "Response Error"))
        }
        return HttpResult.success(dataResponse)
    }
}
