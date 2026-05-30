//
//  MovieResponse.swift
//  Pair
//
//  Created by Evan Best on 2026-04-28.
//

import Foundation

struct MovieResponse: Codable, Identifiable {
	let id: Int
	let title: String
	let overview: String
	let posterPath: String?
	let backdropPath: String?
	let voteAverage: Double
	let voteCount: Int
	let releaseDate: String?
	let genreIds: [Int]
}

struct MovieImagesResponse: Decodable {
	let id: Int
	let logos: [MovieImage]
}

struct MovieImage: Decodable, Identifiable {
	let filePath: String
	let iso6391: String?
	let voteAverage: Double
	let width: Int
	let height: Int

	var id: String { filePath }
}
