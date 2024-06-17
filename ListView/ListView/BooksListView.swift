//
//  BooksListView.swift
//  ListView
//
//  Created by 어재선 on 6/17/24.
//
import SwiftUI

private class BooksViewModel: ObservableObject {
    @Published var books: [Book] = Book.samples
    @Published var fetching = false
    
    @MainActor
    func fetchDate() async {
        fetching = true
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
        } catch { }
        books = Book.samples
        fetching = false
    }
}

struct BooksListView: View {
    @StateObject fileprivate var viewModel = BooksViewModel()

    var body: some View {
        List(viewModel.books) { book in
            BookRowView(book: book)
        }
        .overlay {
            if viewModel.fetching {
                ProgressView("fatching data, please wait...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .animation(.default, value: viewModel.books)
        .task {
            await viewModel.fetchDate()
        }
    }
}

private struct BookRowView: View {
  var book: Book

  var body: some View {
    HStack(alignment: .top) {
      Image(book.mediumCoverImageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 90)
      VStack(alignment: .leading) {
        Text(book.title)
          .font(.headline)
        Text("by \(book.author)")
          .font(.subheadline)
        Text("\(book.pages) pages")
          .font(.subheadline)
      }
      Spacer()
    }
  }
}

#Preview {
    BooksListView()
}
