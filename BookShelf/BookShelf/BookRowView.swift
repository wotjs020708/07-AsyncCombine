//
//  File.swift
//  BookShelf
//
//  Created by 어재선 on 6/17/24.
//

import SwiftUI


struct BookRowView: View {
    var book: Book
    var body: some View {
        HStack(alignment: .top) {
            Image(book.mediumCoverImagename)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 90)
            VStack(alignment: .leading){
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
