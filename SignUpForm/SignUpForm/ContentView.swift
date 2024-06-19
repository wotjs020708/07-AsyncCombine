//
//  ContentView.swift
//  SignUpForm
//
//  Created by 어재선 on 6/18/24.
//

import SwiftUI
import Combine

class SignupFormViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    
    @Published var usernameMessage: String = ""
    @Published var passwordMessage: String = ""
    @Published var isValid: Bool = false
    
    @Published var isUserNameAvailable: Bool = false
    
    private let authenticaitonService = AuthenticationService()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var isUsernameLengthValidPublisher: AnyPublisher<Bool, Never> = {
        $username.map { $0.count >= 3}.eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> = {
        $password.map(\.isEmpty).eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordMatchingPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest($password, $passwordConfirmation)
            .map(==)
            .eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordValidPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordMatchingPublisher)
            .map { !$0 && $1 }
            .eraseToAnyPublisher()
    }()
    
    private lazy var isFormValidPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest3(isUsernameLengthValidPublisher,$isUserNameAvailable, isPasswordValidPublisher)
            .map { $0 && $1 && $2}
            .eraseToAnyPublisher()
    }()
    
//    func checkUserNameAvailable(_ userName: String) {
//        authenticaitonService.checkUserNameAvailableWithClosure(userName: userName) {
//            [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let isAvailable):
//                    self?.isUserNameAvailable = isAvailable
//                case .failure(let error):
//                    print("error: \(error)")
//                    self?.isUserNameAvailable = false
//                }
//            }
//        }
//    }
    
    private lazy var isUsernameAvailablePublisher: AnyPublisher<Bool, Never> = {
        $username
            .debounce(for: 0.5, scheduler:  RunLoop.main)
            .removeDuplicates()
            .flatMap { username -> AnyPublisher<Bool, Never> in
                self.authenticaitonService.checkusernameAvailableNaive(userName: username)
            }
            .receive(on: DispatchQueue.main)
            .share()
            .print("share")
            .eraseToAnyPublisher()
    }()

    
    init() {
        
        isFormValidPublisher
            .assign(to: &$isValid)
        
        Publishers.CombineLatest(isUsernameLengthValidPublisher, isUsernameAvailablePublisher)
            .map { isUsernameLegthvalid, isUserNameAvailable in
                if !isUsernameLegthvalid {
                    return "Username must be at least three characters!"
                } else if !isUserNameAvailable {
                    return "This username is alread taken."
                }
                return ""
            }
            .assign(to: &$usernameMessage)
//        isUsernameLengthValidPublisher.map { $0 ? "" : "Username must be at least three characters!"}
//            .assign(to: &$usernameMessage)
        Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordMatchingPublisher)
            .map { isPasswordEmpty, isPasswordMatching in
                if isPasswordEmpty {
                    return "Password must not be empty"
                } else if !isPasswordMatching {
                    return "Passwords do not match"
                }
                return ""
            }
            .assign(to: &$passwordMessage)
    }
}

struct ContentView: View {
    @StateObject var viewModel = SignupFormViewModel()
    
    var body: some View {
        Form {
            // Username
            Section{
                TextField("Username", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } footer: {
                Text(viewModel.usernameMessage)
                    .foregroundStyle(Color.red)
            }
            // Password
            Section{
                SecureField("Password", text: $viewModel.password)
                SecureField("Repeat Password", text: $viewModel.passwordConfirmation)
                  
            } footer: {
                Text(viewModel.passwordMessage)
                    .foregroundStyle(Color.red)
            }
            // Submit button
            Section{
                
                Button("Sign up") {
                    print("Signing up as \(viewModel.username)")
                }
                .disabled(!viewModel.isValid)
            }
        }
    }
}

#Preview {
    ContentView()
}
