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
		ScrollView {
			VStack(alignment: .leading, spacing: 12) {
				MovieRowSection(
					title: "Top Rated",
					movies: watchVM.topRatedMovies
				)
				.padding(.top, 8)

				MovieRowSection(
					title: "Now Playing in Theatres",
					movies: watchVM.nowPlayingMovies
				)
			}
			.task {
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

private struct MovieRowSection: View {
	let title: String
	let movies: [MovieResponse]

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			SectionHeader(title: title)

			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 6) {
					ForEach(movies, id: \.id) { movie in
						MovieCardItem(movie: movie)
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
		HStack(spacing: 4) {
			Text(title)
				.font(.title2)
				.fontWeight(.semibold)

			Image(systemName: "chevron.right")
				.font(.subheadline.weight(.semibold))
				.foregroundStyle(.tertiary)
		}
		.padding(.horizontal, 16)
	}
}

private struct MovieCardItem: View {
	let movie: MovieResponse

	private let cardWidth: CGFloat = 110
	private let cardHeight: CGFloat = 160
	private let cornerRadius: CGFloat = 16

	var body: some View {
		posterContent
			.frame(width: cardWidth, height: cardHeight)
			.clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
			.glassEffect(
				.regular,
				in: .rect(cornerRadius: 16, style: .continuous)
			)
	}

	private var posterContent: some View {
		Group {
			if let posterURL {
				AsyncImage(url: posterURL) { phase in
					switch phase {
					case .success(let image):
						image
							.resizable()
							.scaledToFill()

					default:
						posterFallback
					}
				}
			} else {
				posterFallback
			}
		}
	}

	private var posterURL: URL? {
		guard
			let posterPath = movie.posterPath?.trimmingCharacters(in: .whitespacesAndNewlines),
			!posterPath.isEmpty
		else {
			return nil
		}

		return URL(string: "https://image.tmdb.org/t/p/w342\(posterPath)")
	}

	private var posterFallback: some View {
		Rectangle()
			.fill(Color.gray.opacity(0.3))
			.overlay {
				Image(systemName: "film")
					.foregroundStyle(.secondary)
			}
	}
}

#Preview {
	NavigationStack {
		WatchMainView(watchVM: WatchViewModel())
	}
}
