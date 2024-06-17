//
//  BooksListView.swift
//  ListView
//
//  Created by 어재선 on 6/17/24.
//
import SwiftUI
import Combine

private extension String {
    func matches(_ searchTerm: String) -> Bool {
        self.range(of: searchTerm, options: .caseInsensitive) != nil
    }
}

private class BooksViewModel: ObservableObject {
    @Published var books: [Book] = Book.samples
    @Published var fetching = false
    @Published var serchTerm: String = ""
    
    @Published var filterdBooks: [Book] = [Book]()
    
    init() {
        Publishers.CombineLatest($books, $serchTerm)
            .map { books, serchTerm in
                books.filter { book in
                    serchTerm.isEmpty ? true : (book.title.matches(serchTerm)) || book.author.matches(serchTerm)
                }
            }
            .assign(to: &$filterdBooks)
    }
    
    @MainActor
    func fetchDate() async {
        fetching = true
        books.removeAll()
        do {
            try await Task.sleep(for: .seconds(2))
        } catch { }
        books = Book.samples
        fetching = false
    }
}

struct BooksListView: View {
    @StateObject fileprivate var viewModel = BooksViewModel()

    var body: some View {
        List(viewModel.filterdBooks) { book in
            BookRowView(book: book)
        }
        .searchable(text: $viewModel.serchTerm)
        .autocapitalization(.none)
        .refreshable {
            await viewModel.fetchDate()
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
    NavigationStack {
        BooksListView()        
    }
}
