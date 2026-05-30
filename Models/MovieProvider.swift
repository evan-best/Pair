//
//  MovieProvider.swift
//  Pair
//
//  Created by Evan Best on 2026-05-30.
//

import Foundation

// Top-level response from /3/movie/{id}/watch/providers.
struct WatchProvidersResponse: Decodable {
	let id: Int
	let results: [String: CountryProviders]
}

// One country's availability, split by offering.
struct CountryProviders: Decodable {
	let link: String?
	let flatrate: [MovieProvider]?
	let rent: [MovieProvider]?
	let buy: [MovieProvider]?
	let ads: [MovieProvider]?
}

// A single streaming service.
struct MovieProvider: Decodable, Identifiable, Hashable {
	let providerId: Int
	let providerName: String
	let logoPath: String?
	let displayPriority: Int

	var id: Int { providerId }

	// Build logo URL.
	func logoURL(size: String = "w92") -> URL? {
		guard let logoPath else { return nil }
		return URL(string: "https://image.tmdb.org/t/p/\(size)\(logoPath)")
	}
}
