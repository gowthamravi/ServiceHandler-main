//
//  NetworkService.swift
//  Atheletes
//
//  Created by Gowtham, Ravikumar on 07/09/22.
//

import Foundation

public protocol NetworkServiable {
    func fetch<T>(request: Request<T>) async throws -> T
}

public class NetworkService: NetworkServiable {

    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    public func fetch<T>(request: Request<T>) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request.request)

            guard let response = response as? HTTPURLResponse else {
                throw RequestError.invalidURL
            }

            switch response.statusCode {
            case 200...299: break
            case 300...399:
                throw RequestError.redirection
            case 400...499:
                throw RequestError.clientError
            case 500...599:
                throw RequestError.serverError
            default:
                throw RequestError.unexpectedStatusCode
            }

            guard let decodedResponse = try? decoder.decode(request.responseType, from: data) else {
                if data.isEmpty {
                    return String() as! T
                }
                throw RequestError.decode
            }
            return decodedResponse
        } catch {
            if let error = error as? RequestError { throw error }

            let error = error as NSError
            if error.domain == NSURLErrorDomain,
               error.code == NSURLErrorNotConnectedToInternet {
                throw RequestError.noNetwork
            } else {
                throw RequestError.unknown
            }
        }
    }
}
