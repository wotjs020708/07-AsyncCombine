//
//  SettingScreen.swift
//  StateManagement
//
//  Created by 어재선 on 6/17/24.
//

import SwiftUI

struct SettingScreen: View {
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Settings")) {
                    NavigationLink(destination: UserProfileScreen()){
                        Text("User Profile")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        SettingScreen()
    }
}
