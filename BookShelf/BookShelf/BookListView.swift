//
//  ContentView.swift
//  BookShelf
//
//  Created by 어재선 on 6/17/24.
//

import SwiftUI

class BooksViewmodel: ObservableObject {
    @Published var books: [Book] = Book.sampleBooks
}

struct BookListView: View {
    @StateObject var booksViewMdoel = BooksViewmodel()
    
    var body: some View {
        NavigationStack {
            List ($booksViewMdoel.books) { $book in
                NavigationLink(destination: BookDetailView(book: $book)) {
                    BookRowView(book: book)
                }
                
            }
            .listStyle(.plain)
            .navigationTitle("Books")
        }
        
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BookListView()
}
