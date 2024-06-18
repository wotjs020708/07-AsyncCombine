//
//  ContentView.swift
//  SignUpForm
//
//  Created by 어재선 on 6/18/24.
//

import SwiftUI

class SignupFormViewModel: ObservableObject {
    @Published var username: String = " "
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
