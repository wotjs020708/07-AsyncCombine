//
//  SignUpFormViewModel.swift
//  SignUpFrom2
//
//  Created by 어재선 on 6/20/24.
//

import Foundation
import Combine

class SignUpFormViewModel: ObservableObject{
    typealias Available = Result<Bool, Error>
    
    @Published var username: String = ""
    @Published var usernameMessage: String = ""
    @Published var isValid: Bool = false
    @Published var showUpdateDialog: Bool = false
    
    private var authenticationService = AuthenticationService()
    
    private lazy var isUserNameAvailablePublisher: AnyPublisher<Available, Never> = {
        $username
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { username -> AnyPublisher<Available, Never> in
                self.authenticationService.checkUserNameAvailablePublisher(userName: username)
                    .asREsult()
            }
            .share()
            .eraseToAnyPublisher()
    }()
}
