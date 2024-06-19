//
//  AuthenticationService.swift
//  SignUpForm
//
//  Created by 어재선 on 6/19/24.
//

import Foundation

struct UserNameAvailableMessage: Codable {
    var isAvailable: Bool
    var userName: String
    
}

enum NetworkError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
    case encodingError(Error)
    
}



class AuthenticationService {
    func checkUserNameAvailableWithClosure(userName: String, completion: @escaping (Result<Bool, NetworkError>) -> Void ) {
        
        let url = URL(string: "http://127.0.0.1:8080/isUserNameAvailable?userName=\(userName)")!
        
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            if let response = response as? HTTPURLResponse,
               !(200..<300).contains(response.statusCode) { // 응답이 200번때가 아니면 실패
                completion(.failure(.serverError(statusCode: response.statusCode)))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userAvailableMessage = try decoder.decode(UserNameAvailableMessage.self, from: data)
                completion(.success(userAvailableMessage.isAvailable))
                
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}
