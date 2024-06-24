//
//  ContentView.swift
//  WordBrowser
//
//  Created by 어재선 on 6/24/24.
//

import SwiftUI

struct SectionView: View {
    var title: String
    var words: [String]
    
    init(_ title: String, words: [String]) {
        self.title = title
        self.words = words
    }
    var body: some View {
        Section(title) {
            if words.isEmpty {
                Text("(No items match your filter criteria")
            } else {
                ForEach(words, id: \.self) { word in
                    Text(word)
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = LibraryViewModel()
    @State var isAddNewWordDialogPresnted = false
    var body: some View {
        List {
            SectionView("Random Word", words: [viewModel.randomWord])
            SectionView("Peter's Tips", words: viewModel.filteredTips)
            SectionView("my favorites", words: viewModel.filteredFavorites)
        }
        .searchable(text: $viewModel.searchText)
        .textInputAutocapitalization(.never)
        .navigationTitle("Libary")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { isAddNewWordDialogPresnted.toggle()}) {
                    
                    Image(systemName: "plus")
                }
            }
        }
        .refreshable {
            print("\(#function) is on main thread BEFORE await \(Thread.isMainThread)")
            await viewModel.refresh()
            print("\(#function) is on main thread AFTER await \(Thread.isMainThread)")
        }
        .sheet(isPresented: $isAddNewWordDialogPresnted){
            NavigationStack {
                AddWordView{ word in
                        print(word)
                    viewModel.addFavorite(word)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
