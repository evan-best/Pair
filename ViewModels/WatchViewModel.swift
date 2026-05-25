//
//  MovieSearchViewModel.swift
//  Pair
//
//  Created by Evan Best on 2026-05-02.
//

import Foundation

@Observable
final class WatchViewModel {
	let service = TMDBService()

	// MARK: Featured
	var topRatedMovies = [MovieResponse]()
	var isFetchingTopRated: Bool = false
	
	// MARK: Now Playing
	var nowPlayingMovies = [MovieResponse]()
	var isFetchingNowPlaying: Bool = false
	
	// MARK: Featured (Weekly)
	var featuredMovies = [MovieResponse]()
	var isFetchingFeatured = false
	// MARK: Search
	var searchResults = [MovieResponse]()
	var searchTerm: String = ""
	var isSearching: Bool = false
	
	var error: String? = nil

	
	func fetchTopRated() async {
		isFetchingTopRated = true
		defer { isFetchingTopRated = false }
		do {
			topRatedMovies = try await service.fetchTopRated()
		} catch {
			self.error = error.localizedDescription
		}
	}
	
	func fetchFeatured() async {
		isFetchingFeatured = true
		
		defer { isFetchingFeatured = false }
		do {
			featuredMovies = try await service.fetchFeatured()
		} catch {
			self.error = error.localizedDescription
		}
	}
	
	func fetchNowPlaying() async {
		isFetchingNowPlaying = true
		defer { isFetchingNowPlaying = false }
		do {
			nowPlayingMovies = try await service.fetchNowPlaying()
		} catch {
			self.error = error.localizedDescription
		}
	}
	
	func search() async {
		let query = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !query.isEmpty else {
			searchResults = []
			error = nil
			return
		}

		isSearching = true
		error = nil

		defer { isSearching = false }
		do {
			searchResults = try await service.searchMovies(query: query)
		} catch {
			searchResults = []
			self.error = error.localizedDescription
		}
	}
}
