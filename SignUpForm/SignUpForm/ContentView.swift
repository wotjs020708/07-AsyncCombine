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
    
    private lazy var isUsernameLengthValidpublisher: AnyPublisher<Bool, Never> = {
        $username.map { $0.count >= 3}.eraseToAnyPublisher()
    }()
    
    init() {
        isUsernameLengthValidpublisher
            .assign(to: &$isValid)
        isUsernameLengthValidpublisher.map { $0 ? "" : "Username must be at least three characters!"}
            .assign(to: &$usernameMessage)
    }
}

struct ContentView: View {
    @StateObject var viewModel = SignupFormViewModel()
    
    var body: some View {
        Form {
            // Username
            Section{
                TextField("Username", text: $viewModel.username)
                    .textInputAutocapitalization(.none)
                    .autocorrectionDisabled()
            } footer: {
                Text(viewModel.usernameMessage)
                    .foregroundStyle(Color.red)
            }
            // Password
            Section{
                TextField("Password", text: $viewModel.password)
                TextField("Repeat Password", text: $viewModel.passwordConfirmation)
                  
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
