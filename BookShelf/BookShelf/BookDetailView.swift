//
//  BookDetailView.swift
//  BookShelf
//
//  Created by 어재선 on 6/17/24.
//

import SwiftUI

struct BookDetailView: View {
    @Binding var book: Book
    @State var showEditBookView = false
    var body: some View {
        Form {
            Text(book.title)
            Image(book.largeCoverImagename)
                .resizable()
                .scaledToFit()
                .shadow(radius: 10)
                .padding()
            Button(action: {showEditBookView.toggle()}) {
                Label("Edit", systemImage: "pencil")
            }
            Label(book.author, systemImage: "person.crop.rectangle")
            Label("\(book.pages) pages", systemImage: "book")
            Toggle("Read", isOn: .constant(book.isRead))
        }
        .navigationTitle(book.title)
        .sheet(isPresented: $showEditBookView) {
            BookEditView(book: book)
        }
    }
}

#Preview {
    
    NavigationStack{
        BookDetailView(book: .constant(Book.sampleBooks[0]))
    }
}
