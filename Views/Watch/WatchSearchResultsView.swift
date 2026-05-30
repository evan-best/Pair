//
//  WatchSearchResultsView.swift
//  Pair
//
//  Created by Evan Best on 2026-05-02.
//

import SwiftUI

struct MovieSearchResultsView: View {
	let watchVM: WatchViewModel

	var body: some View {
		Group {
			if watchVM.isSearching {
				VStack(spacing: 12) {
					ProgressView()
					Text("Searching...")
						foregroundStyle(.secondary)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			} else if let error = watchVM.error, !error.isEmpty {
				ContentUnavailableView("Search Failed", systemImage: "exclamationmark.triangle", description: Text(error))
			} else if watchVM.searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
				ContentUnavailableView("Search Movies", systemImage: "magnifyingglass", description: Text("Find something to watch."))
			} else if watchVM.searchResults.isEmpty {
				ContentUnavailableView("No Results", systemImage: "film", description: Text("Try a different title."))
			} else {
				ScrollView {
					LazyVStack(alignment: .leading, spacing: 16) {
						ForEach(watchVM.searchResults, id: \.id) { movie in
							MovieSearchResultRow(movie: movie)
						}
					}
					.padding(.horizontal, 16)
					.padding(.vertical, 12)
				}
			}
		}
	}
}

private struct MovieSearchResultRow: View {
	let movie: MovieResponse

	var body: some View {
		HStack(alignment: .top, spacing: 12) {
			TMDBImageView(
				path: movie.posterPath,
				size: .poster,
				contentMode: .fill
			)
			.frame(width: 88, height: 128)
			.clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

			VStack(alignment: .leading, spacing: 8) {
				Text(movie.title)
					.font(.headline)
					foregroundStyle(.primary)

				if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
					Text(releaseDate)
						.font(.subheadline)
						foregroundStyle(.secondary)
				}

				Text(movie.overview)
					.font(.subheadline)
					foregroundStyle(.secondary)
					.lineLimit(4)
			}

			Spacer(minLength: 0)
		}
	}
}

#Preview {
	MovieSearchResultsView(watchVM: WatchViewModel())
}
