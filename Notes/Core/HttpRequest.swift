//
//  HttpRequest.swift
//  Notes
//
//  Created by Gopinath.A on 26/02/21.
//

enum HttpMethod {
     case GET
}

struct HttpRequest {
    let method: HttpMethod
    let url: String
    let body: [String: String]?
    let headers: [String: String]?
}
