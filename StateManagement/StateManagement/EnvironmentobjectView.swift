//
//  EnvironmentobjectView.swift
//  StateManagement
//
//  Created by 어재선 on 6/17/24.
//

import SwiftUI

class UserProfile: ObservableObject {
    @Published var name: String
    @Published var favoriteProgrammingLanguage: String
    @Published var favoriteColor: Color
    
    init(name: String, favoriteProgrammingLanguage: String, favoriteColor: Color) {
        self.name = name
        self.favoriteProgrammingLanguage = favoriteProgrammingLanguage
        self.favoriteColor = favoriteColor
    }
}

struct EnvironmentobjectView: View {
    @StateObject var profile = UserProfile(name: "Peter1", favoriteProgrammingLanguage: "Swift", favoriteColor: .pink)
    @State var isSettingShown = false
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section {
                    Text("This is  just some random data")
                    Text("Let's assume this was the main screen of an app")
                    Text("Tap the cog icon to go gto the fake settings screen")
                }
                
            }
            HStack {
                Text("Sign in as \(profile.name)")
                    .foregroundStyle(Color(UIColor.systemBackground))
                Spacer()
            }
            .padding(30)
            .background(profile.favoriteColor)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("@EnvironmentObject")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: showSetting) {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $isSettingShown){
            NavigationStack{
                SettingScreen()
            }
            .environmentObject(profile)
        }   
    }
    func showSetting() {
        isSettingShown.toggle()
    }
    
}

#Preview {
    NavigationStack{
        EnvironmentobjectView()
        
    }
}
