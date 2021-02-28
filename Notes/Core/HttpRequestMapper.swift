//
//  HttpRequestMapper.swift
//  Notes
//
//  Created by Gopinath.A on 26/02/21.
//

import Foundation

protocol HttpRequestMapper {
    func map(httpRequest: HttpRequest) -> URLRequest?
}

class HttpRequestMapperImpl: HttpRequestMapper {
  
    func map(httpRequest: HttpRequest) -> URLRequest? {
        switch httpRequest.method {
        case .GET:
            return mapToGet(httpRequest: httpRequest)
        }
    }
    
    private func mapToGet(httpRequest: HttpRequest) -> URLRequest? {
        guard var request = urlRequest(httpRequest: httpRequest) else {
            return nil
        }
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        return request
    }

//    private func mapToPost(httpRequest: HttpRequest) -> URLRequest? {
//        guard var request = urlRequest(httpRequest: httpRequest) else {
//            return nil
//        }
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        
//        let parameters: [String: Any] = [
//            "id": 13,
//            "name": "Jack & Jill"
//        ]
//        
//        let body  = try? NSKeyedArchiver.archivedData(withRootObject: parameters, requiringSecureCoding: true)
//        request.httpBody = body
//
//        return request
//    }

    private func urlRequest(httpRequest: HttpRequest) -> URLRequest? {
        guard let url = URL(string: httpRequest.url) else {
            return nil
        }
        return URLRequest(url:url)
    }
    
}
