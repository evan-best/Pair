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

	private let baseURL = URL(string: "https://api.themoviedb.org")!
	private let accessToken = Bundle.main.infoDictionary?["TMDB_READ_TOKEN"] as! String

	private func fetch<T: Decodable>(_ url: URL) async throws -> T {
		var request = URLRequest(url: url)
		request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

		let (data, urlResponse) = try await URLSession.shared.data(for: request)

		guard let httpResponse = urlResponse as? HTTPURLResponse,
			  httpResponse.statusCode == 200 else {
			throw TMDBError.invalidResponse
		}

		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return try decoder.decode(T.self, from: data)
	}
	/// Search for movies using TMDB API
	/// - Parameter query: Query for searching.
	/// - Returns: Array of MovieResponse objects (search results).
	func searchMovies(query: String) async throws -> [MovieResponse] {
		var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
		components.path = "/3/search/movie"
		components.queryItems = [
			URLQueryItem(name: "query", value: query)
		]

		let response: TMDBSearchResponse = try await fetch(components.url!)
		return response.results
	}
}
