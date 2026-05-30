//
//  WatchView.swift
//  Pair
//
//  Created by Evan Best on 2026-05-02.
//

import SwiftUI

struct WatchMainView: View {
	let watchVM: WatchViewModel

	var body: some View {
		GeometryReader { proxy in
			ScrollView {
				VStack(alignment: .leading, spacing: 12) {
					MovieRowSection(
						title: "Trending Now",
						movies: watchVM.topRatedMovies
					)
					.padding(.top, 12)

					MovieRowSection(
						title: "Now Playing in Theatres",
						movies: watchVM.nowPlayingMovies
					)
				}
				.task {
					if watchVM.featuredMovies.isEmpty {
						await watchVM.fetchFeatured()
					}

					if watchVM.topRatedMovies.isEmpty {
						await watchVM.fetchTopRated()
					}

					if watchVM.nowPlayingMovies.isEmpty {
						await watchVM.fetchNowPlaying()
					}
				}
			}
		}
	}
}

private struct MovieRowSection: View {
	let title: String
	let movies: [MovieResponse]
	
	@Namespace private var namespace
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			SectionHeader(title: title)

			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 6) {
					ForEach(movies, id: \.id) { movie in
						NavigationLink {
							MovieDetailView(movie: movie)
								.navigationTransition(.zoom(sourceID: movie.id, in: namespace))
						} label: {
							MovieCardItem(movie: movie)
								.matchedTransitionSource(id: movie.id, in: namespace)
						}
					}
				}
				.padding(.horizontal, 16)
			}
		}
	}
}

private struct SectionHeader: View {
	let title: String

	var body: some View {
		HStack(alignment: .firstTextBaseline, spacing: 4) {
			Text(title)
				.font(.title2)
				.fontWeight(.semibold)
			Image(systemName: "chevron.right")
				.font(.system(size: 16))
				.fontWeight(.semibold)
				.foregroundStyle(.secondary)
		}
		.padding(.horizontal, 16)
	}
}

private struct MovieCardItem: View {
	let movie: MovieResponse

	private let cardWidth: CGFloat = 110
	private let cardHeight: CGFloat = 160
	private let cornerRadius: CGFloat = 14

	var body: some View {
		TMDBImageView(
			path: movie.posterPath,
			size: .poster,
			contentMode: .fill
		)
		.frame(width: cardWidth, height: cardHeight)
		.clipShape(
			RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
		)
		.glassEffect(
			.regular,
			in: .rect(cornerRadius: 16, style: .continuous)
		)
	}
}

#Preview {
	NavigationStack {
		WatchMainView(watchVM: WatchViewModel())
	}
}
