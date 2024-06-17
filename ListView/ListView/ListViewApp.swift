//
//  ListViewApp.swift
//  ListView
//
//  Created by 어재선 on 6/17/24.
//

import SwiftUI

@main
struct ListViewApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                    BooksListView()
            }
            
        }
    }
}
