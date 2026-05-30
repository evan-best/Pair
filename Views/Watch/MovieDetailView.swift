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
	@State private var runtime: Int?
	@State private var certification: String?
	@State private var isReady = false
	@State private var vm = WatchViewModel()

	var body: some View {
		ScrollView {
			heroImage
		}
		.background(Color.black.ignoresSafeArea())
		.opacity(isReady ? 1 : 0)
		.ignoresSafeArea(edges: .top)
		.task {
			await load()
		}
	}

	private func load() async {
		async let logo = vm.fetchLogo(for: movie.id)
		async let length = vm.fetchRuntime(for: movie.id)
		async let cert = vm.fetchCertification(for: movie.id)

		let fetchedLogo = await logo
		runtime = await length
		certification = await cert

		// Warm the URL cache for the backdrop + logo before revealing the view
		// so the fade-in shows the final images, not placeholders.
		async let backdropCached: Void = cacheImage(path: movie.backdropPath, size: .backdrop)
		async let logoCached: Void = cacheImage(path: fetchedLogo, size: .logo)
		_ = await (backdropCached, logoCached)

		logoPath = fetchedLogo

		withAnimation(.easeIn(duration: 0.35)) {
			isReady = true
		}
	}

	private func cacheImage(path: String?, size: TMDBImageSize) async {
		guard let url = TMDBImageView.url(for: path, size: size) else { return }
		let request = URLRequest(url: url)
		if URLCache.shared.cachedResponse(for: request) != nil { return }
		guard let (data, response) = try? await URLSession.shared.data(for: request) else { return }
		URLCache.shared.storeCachedResponse(
			CachedURLResponse(response: response, data: data),
			for: request
		)
	}

	// MARK: Hero

	private var heroImage: some View {
		TMDBImageView(path: movie.backdropPath, size: .backdrop, contentMode: .fill)
			.frame(height: 520)
			.frame(maxWidth: .infinity)
			.overlay(alignment: .bottom) { blurFade }
			.overlay(alignment: .bottom) { darkenFade }
			.overlay(alignment: .bottom) {
				heroContent
					.padding(.horizontal, 12)
					.padding(.bottom, 12)
			}
	}

	private var blurFade: some View {
		Rectangle()
			.fill(.ultraThinMaterial)
			.frame(height: 260)
			.mask {
				LinearGradient(
					colors: [.clear, .gray.opacity(0.5), .black],
					startPoint: .top,
					endPoint: .bottom
				)
			}
	}

	private var darkenFade: some View {
		LinearGradient(
			colors: [.clear, .black.opacity(0.35)],
			startPoint: .center,
			endPoint: .bottom
		)
	}

	private var heroContent: some View {
		VStack(spacing: 12) {
			logoOrTitle
			Text(typeAndGenreLine)
				.font(.footnote)
				.foregroundStyle(.white.opacity(0.85))
				.padding(.bottom, 8)
			actionButtons
			detailsBlock
		}
	}

	@ViewBuilder
	private var logoOrTitle: some View {
		if let logoPath {
			AsyncImage(
				url: URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)")
			) { phase in
				if let image = phase.image {
					image.resizable().scaledToFit()
				}
			}
			.frame(maxWidth: 220, maxHeight: 70)
		} else {
			Text(movie.title)
				.font(.title2.bold())
				.foregroundStyle(.white)
		}
	}

	private var actionButtons: some View {
		HStack {
			Button {
				// play trailer
			} label: {
				Label("Preview", systemImage: "play.fill")
					.foregroundStyle(.black)
					.fontWeight(.semibold)
					.padding(.vertical, 6)
					.padding(.horizontal, 8)
			}
			.buttonStyle(.glass(.regular.tint(.white)))
			.controlSize(.small)

			Button {
				// add to watchlist
			} label: {
				Image(systemName: "plus")
					.foregroundStyle(.white)
					.fontWeight(.semibold)
					.padding(6)
			}
			.controlSize(.regular)
			.buttonStyle(.glass)
			.buttonBorderShape(.circle)
		}
	}

	private var detailsBlock: some View {
		HStack(spacing: 12) {
			Text("\(yearText)  •  \(lengthText)")
				.font(.caption2.weight(.semibold))
				.foregroundStyle(.white.opacity(0.8))
			ratingBadge
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.top, 16)
	}

	private var ratingBadge: some View {
		Text(ratingText)
			.font(.caption2.weight(.semibold))
			.foregroundStyle(.white.opacity(0.8))
			.tracking(-0.2)
			.foregroundStyle(.white)
			.padding(.horizontal, 4)
			.overlay(
				RoundedRectangle(cornerRadius: 3, style: .continuous)
					.stroke(Color.white.opacity(0.8), lineWidth: 1)
			)
	}

	private var typeAndGenreLine: String {
		var parts: [String] = ["Movie"]
		for id in movie.genreIds {
			if let name = Self.genreName(for: id) {
				parts.append(name)
				break
			}
		}
		return parts.joined(separator: "  •  ")
	}

	private var metaLine: String {
		"\(yearText)  •  \(lengthText)  •  \(ratingText)"
	}

	private var yearText: String {
		guard let date = movie.releaseDate, date.count >= 4 else { return "—" }
		return String(date.prefix(4))
	}

	private var lengthText: String {
		guard let runtime else { return "—" }
		return Self.formatRuntime(runtime)
	}

	private var ratingText: String {
		guard let cert = certification, !cert.isEmpty else { return "—" }
		return cert
	}

	nonisolated private static func formatRuntime(_ minutes: Int) -> String {
		let hours = minutes / 60
		let mins = minutes % 60
		if hours > 0 {
			return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
		}
		return "\(mins)m"
	}

	nonisolated private static let genreNames: [Int: String] = [
		28: "Action",
		12: "Adventure",
		16: "Animation",
		35: "Comedy",
		80: "Crime",
		99: "Documentary",
		18: "Drama",
		10751: "Family",
		14: "Fantasy",
		36: "History",
		27: "Horror",
		10402: "Music",
		9648: "Mystery",
		10749: "Romance",
		878: "Sci-Fi",
		10770: "TV Movie",
		53: "Thriller",
		10752: "War",
		37: "Western",
	]

	nonisolated private static func genreName(for id: Int) -> String? {
		genreNames[id]
	}
}

#Preview {
	MovieDetailView(
		movie: MovieResponse(
			id: 1,
			title: "Preview Movie",
			overview: "An example overview that is very long and that should become truncated very soon if i keep typing then it should ",
			posterPath: "",
			backdropPath: "",
			voteAverage: 0,
			voteCount: 0,
			releaseDate: nil,
			genreIds: [28]
		)
	)
}
