//
//  TMDBService.swift
//  Pair
//
//  Created by Evan Best on 2026-05-02.
//

import Foundation


enum TMDBError: Error {
	case noData
	case invalidResponse
	case invalidData
	case unknown
}

struct TMDBSearchResponse: Codable {
	let results: [MovieResponse]
}

@Observable
final class TMDBService {
	
	private let baseURL = URL(string: Bundle.main.infoDictionary?["TMDB_BASE_URL"] as! String)!
	private let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as! String
	
	private func fetch<T: Decodable>(_ url: URL) async throws -> T {
		let (data, urlResponse) = try await URLSession.shared.data(from: url)
		
		guard let httpResponse = urlResponse as? HTTPURLResponse,
			  httpResponse.statusCode == 200 else {
			throw TMDBError.invalidResponse
		}
		
		return try JSONDecoder().decode(T.self, from: data)
	}
	
	
	/// Search for movies using TMDB API
	/// - Parameter query: Query for searching.
	/// - Returns: MovieResponse object (search results).
	func searchMovies(query: String) async throws -> [MovieResponse] {
		var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
		components.path.append("/search/movie")
		components.queryItems = [
			URLQueryItem(name: "api_key", value: apiKey),
			URLQueryItem(name: "query", value: query),
		]
		
		let response: TMDBSearchResponse = try await fetch(components.url!)
		return response.results
		
	}
	
}
