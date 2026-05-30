//
//  MovieDetailView.swift
//  Pair
//
//  Created by Evan Best on 2026-05-30.
//

import SwiftUI

struct MovieDetailView: View {
	let movie: MovieResponse

	@State private var logoPath: String?  // ← nil until the fetch lands
	@State private var vm = WatchViewModel()

	var body: some View {
		ScrollView {
			TMDBImageView(path: movie.backdropPath, size: .backdrop, contentMode: .fill, fallbackSystemImage: "film")
				.frame(maxWidth: .infinity)
				.frame(height: 480)

				// 1. frosted blur fading in toward bottom
				.overlay(alignment: .bottom) {
					Rectangle()
						.fill(.ultraThinMaterial)
						.frame(height: 220)
						.mask {
							LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
						}
				}
				// 2. subtle darkening so white/black text pops on the blur
				.overlay(alignment: .bottom) {
					LinearGradient(colors: [.clear, .black.opacity(0.35)], startPoint: .center, endPoint: .bottom)
				}
				.clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
			.overlay(alignment: .bottom) {
				VStack(spacing: 16) {
					// logo if we have one, else fall back to title
					if let logoPath {
						TMDBImageView(
							path: logoPath,
							size: .logo,
							contentMode: .fit,
							fallbackSystemImage: "film"
						)
						.frame(maxWidth: 220, maxHeight: 80)
					} else {
						Text(movie.title)
							.font(.title.bold())
							.foregroundStyle(.white)
					}

					// buttons
					HStack {
						Button {
							// play trailer
						} label: {
							Label("Preview", systemImage: "play.fill")
								.foregroundStyle(.black)
								.fontWeight(.semibold)
								.padding(.vertical, 4)
								.padding(.horizontal, 6)
						}
						.buttonStyle(.glass(.clear.tint(.white)))
						.controlSize(.small)

						// ADD — regular glass, white icon
						Button {
							// add to watchlist
						} label: {
							Image(systemName: "plus")
								.foregroundStyle(.white)
								.fontWeight(.semibold)
								.padding(4)
						}
						.controlSize(.regular)
						.buttonStyle(.glass)
						.buttonBorderShape(.circle)


					}
				}
				.padding(.bottom, 24)
			}
			Spacer()
		}
		.ignoresSafeArea(edges: .top)
		.task {
			logoPath = try? await vm.fetchLogo(for: movie.id)
		}
	}
}

#Preview {
	MovieDetailView(
		movie: MovieResponse(
			id: 1,
			title: "Preview Movie",
			overview: "An example overview.",
			posterPath: nil,
			backdropPath: nil,
			voteAverage: 0,
			voteCount: 0,
			releaseDate: nil,
			genreIds: []
		)
	)
}
