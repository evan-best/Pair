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
	case missingToken
}

struct TMDBSearchResponse: Codable {
	let results: [MovieResponse]
}

struct TMDBCategory: Codable {
	let id: Int
	let name: String
}

@Observable
final class TMDBService {
	private let baseURL = URL(string: "https://api.themoviedb.org")!
	
	private var client: APIClient {
		get throws {
			guard
				let token = Bundle.main.infoDictionary?["TMDB_READ_TOKEN"] as? String,
				!token.isEmpty,
				!token.contains("$(")
			else {
				throw TMDBError.missingToken
			}
			
			return APIClient(
				baseURL: baseURL,
				authHeaderValue: "Bearer \(token)"
			)
		}
	}
	
	/// Fetch this week's trending movies from TMDB API.
	/// - Returns: Array of MovieResponse objects (results).
	func fetchFeatured() async throws -> [MovieResponse] {
		let response: TMDBSearchResponse = try await client.fetch(
			"/3/trending/movie/week",
			queryItems: [
				URLQueryItem(name: "limit", value: "5")
			]
		)
		print(response)
		return response.results
	}
	
	/// Fetch top rated movies from TMDB API.
	/// - Returns: Array of MovieResponse objects (results).
	func fetchTopRated() async throws -> [MovieResponse] {
		let response: TMDBSearchResponse = try await client.fetch(
			"/3/movie/top_rated"
		)
		return response.results
	}
	
	/// Fetch movies playing in theatres.
	/// - Returns: Array of MovieResponse objects (results).
	func fetchNowPlaying() async throws -> [MovieResponse] {
		let response: TMDBSearchResponse = try await client.fetch(
			"/3/movie/now_playing",
			queryItems: [
				URLQueryItem(name: "language", value: "en-US"),
				URLQueryItem(name: "page", value: "1")
			]
		)
		return response.results
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
