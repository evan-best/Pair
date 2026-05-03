//
//  TMDBService.swift
//  Pair
//
//  Created by Evan Best on 2026-05-02.
//

import Foundation

enum TMDBError: Error {
	case invalidResponse
	case invalidData
}

struct TMDBSearchResponse: Codable {
	let results: [MovieResponse]
}

@Observable
final class TMDBService {

	private let client = APIClient(
		baseURL: URL(string: "https://api.themoviedb.org")!,
		authHeaderValue:
			"Bearer \(Bundle.main.infoDictionary?["TMDB_READ_TOKEN"] as! String)"
	)

	/// Fetch popular movies from TMDB API.
	/// - Returns: Array of MovieResponse objects (results).
	func fetchPopularMovies() async throws -> [MovieResponse] {
		let response: TMDBSearchResponse = try await client.fetch(
			"/3/movie/popular"
		)
		return response.results.prefix(4).map { $0 }
	}

	/// Search for movies using TMDB API
	/// - Parameter query: Query for searching.
	/// - Returns: Array of MovieResponse objects (search results).
	func searchMovies(query: String) async throws -> [MovieResponse] {
		let response: TMDBSearchResponse = try await client.fetch(
			"/3/search/movie",
			queryItems: [
				URLQueryItem(
					name: "query",
					value: query
				)
			]
		)
		return response.results
	}
}
