//
//  HTTPMethod.swift
//  Atheletes
//
//  Created by Gowtham, Ravikumar on 07/09/22.
//

import Foundation

public enum HTTPMethod {
    case get
    case post(Encodable)
    case put(Encodable)
    case patch(Encodable)
    case delete

    var string: String {
        switch self {
        case .get: return "get"
        case .post: return "post"
        case .put: return "put"
        case .patch: return "patch"
        case .delete: return "delete"
        }
    }
}
