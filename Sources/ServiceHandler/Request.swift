//
//  Request.swift
//  Atheletes
//
//  Created by Gowtham, Ravikumar on 07/09/22.
//

import Foundation
import SwiftUI

public struct Request<T: Decodable> {
    let request: URLRequest
    let responseType: T.Type
    
    public init(url: URL, httpMethod: HTTPMethod) {
        var urlRequest: URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.string

            if case let .post(body) = httpMethod {
                request.httpBody = body.toJSONData()
                request.allHTTPHeaderFields = [
                    "Content-Type" : "application/json"
                ]
            }
            
            request.allHTTPHeaderFields = [
                "Content-Type" : "application/json",
                "client":"ios",
                "client-version":"3.999.0"
            ]

            return request
        }

        self.request = urlRequest
        self.responseType = T.self
    }
}

extension Encodable {
    func toJSONData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
