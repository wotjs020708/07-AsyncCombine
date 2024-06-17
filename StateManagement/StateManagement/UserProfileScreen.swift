//
//  UserProfileScreen.swift
//  StateManagement
//
//  Created by 어재선 on 6/17/24.
//

import SwiftUI

struct UserProfileScreen: View {
    @EnvironmentObject var profile: UserProfile
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("user Profile")) {
                    TextField("Name", text: $profile.name)
                    TextField("Favorite Programming Language", text: $profile.favoriteProgrammingLanguage)
                    ColorPicker("Favorti color", selection: $profile.favoriteColor)
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        UserProfileScreen()
            .environmentObject(UserProfile(name: "Perter", favoriteProgrammingLanguage: "Swift", favoriteColor: .pink))
        
    }
}
