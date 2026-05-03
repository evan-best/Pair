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
	var popularMovies = [MovieResponse]()
	var isFetchingPopular: Bool = false
	
	// MARK: Search
	var searchResults = [MovieResponse]()
	var searchTerm: String = ""
	var isSearching: Bool = false
	
	var error: String? = nil

	
	func fetchPopular() async {
		isFetchingPopular = true
		defer { isFetchingPopular = false }
		do {
			popularMovies = try await service.fetchPopularMovies()
		} catch {
			self.error = error.localizedDescription
		}
		isFetchingPopular = false
	}
	
	func search() async {
		guard !searchTerm.isEmpty else { return }
		isSearching = true

		defer { isSearching = false }
		do {
			searchResults = try await service.searchMovies(query: searchTerm)
		} catch {
			self.error = error.localizedDescription
		}
	}
}
