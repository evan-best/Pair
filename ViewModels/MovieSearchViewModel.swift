//
//  MovieSearchViewModel.swift
//  Pair
//
//  Created by Evan Best on 2026-05-02.
//

import Foundation

@Observable
final class MovieSearchViewModel {
	let service = TMDBService()
	
	var searchResults = [MovieResponse]()
	var searchTerm: String = ""
	var searchError: String? = nil
	var isSearching: Bool = false
	
	func search() async {
		guard !searchTerm.isEmpty else { return }
		isSearching = true
		
		defer { isSearching = false }
		do {
			searchResults = try await service.searchMovies(query: searchTerm)
		} catch {
			self.searchError = error.localizedDescription
		}
	}
}
