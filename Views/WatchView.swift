//
//  WatchView.swift
//  Pair
//
//  Created by Evan Best on 2026-05-02.
//

import SwiftUI

struct WatchView: View {

    @State private var searchVM = MovieSearchViewModel()
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            List(searchVM.searchResults, id: \.id) { movie in
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.headline)

                    if !movie.overview.isEmpty {
                        Text(movie.overview)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                    }
                }
                .padding(.vertical, 4)
            }
            .overlay {
                if searchVM.searchResults.isEmpty && !searchVM.isSearching {
                    ContentUnavailableView(
                        "Search for a movie",
                        systemImage: "film",
                        description: Text("Enter a title to find something to watch.")
                    )
                }
            }
            .navigationTitle("Watch")
        }
        .searchable(text: $searchText, prompt: "Search movies")
        .onSubmit(of: .search) {
            searchVM.searchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

            Task {
                await searchVM.search()
            }
        }
    }
}

#Preview {
    WatchView()
}
