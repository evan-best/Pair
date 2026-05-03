//
//  APIClient.swift
//  Pair
//
//  Created by Evan Best on 2026-05-02.
//

import Foundation

enum APIError: Error {
	case invalidResponse
	case invalidData
}

final class APIClient {

	private let baseURL: URL
	private let authHeaderValue: String

	init(baseURL: URL, authHeaderValue: String) {
		self.baseURL = baseURL
		self.authHeaderValue = authHeaderValue
	}

	/// Reusable fetch function for API calls.
	/// - Parameters:
	///   - path: The base URL path.
	///   - queryItems: queryItems to append to path.
	/// - Returns: Decoded result.
	func fetch<T: Decodable>(_ path: String, queryItems: [URLQueryItem] = [])
		async throws -> T
	{
		var components = URLComponents(
			url: baseURL,
			resolvingAgainstBaseURL: true
		)!
		components.path = path
		if !queryItems.isEmpty {
			components.queryItems = queryItems
		}

		var request = URLRequest(url: components.url!)
		request.setValue(authHeaderValue, forHTTPHeaderField: "Authorization")

		let (data, urlResponse) = try await URLSession.shared.data(for: request)

		guard let httpResponse = urlResponse as? HTTPURLResponse,
			httpResponse.statusCode == 200
		else {
			throw APIError.invalidResponse
		}

		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return try decoder.decode(T.self, from: data)
	}
}
