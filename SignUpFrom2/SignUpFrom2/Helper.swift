//
//  Helper.swift
//  SignUpFrom2
//
//  Created by 어재선 on 6/20/24.
//

import Foundation
import Combine

struct UserNameAvailableMessage: Codable {
    var isAvailable: Bool
    var userName: String
    
}

struct APIErrorMessage: Decodable {
    var error: Bool
    var reason: Bool
    
}

enum APIError: LocalizedError {
    case invalidResponse
}

extension Publisher {
    func asREsult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map(Result.success)
            .catch { error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}
