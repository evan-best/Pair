//
//  MovieResponse.swift
//  Pair
//
//  Created by Evan Best on 2026-04-28.
//

import Foundation

struct MovieResponse: Codable {
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
