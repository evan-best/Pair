//
//  Movie.swift
//  Pair
//
//  Created by Evan Best on 2026-04-28.
//

import Foundation
import SwiftData

@Model
class Movie {
	@Attribute(.unique) var id: Int
	var title: String
	var overview: String
	var posterPath: String?
	var backdropPath: String?
	var voteAverage: Double
	var voteCount: Int
	var releaseDate: Date
	var genres: [String]
	var isWatched: Bool
	var addedAt: Date
	var partnerOneVote: Int?
	var partnerTwoVote: Int?
	
	init(id: Int, title: String, overview: String, posterPath: String?, backdropPath: String?, voteAverage: Double, voteCount: Int, releaseDate: Date, genres: [String], isWatched: Bool = false, addedAt: Date = .now, partnerOneVote: Int? = nil, partnerTwoVote: Int? = nil) {
		self.id = id
		self.title = title
		self.overview = overview
		self.posterPath = posterPath
		self.backdropPath = backdropPath
		self.voteAverage = voteAverage
		self.voteCount = voteCount
		self.releaseDate = releaseDate
		self.genres = genres
		self.isWatched = isWatched
		self.addedAt = addedAt
		self.partnerOneVote = partnerOneVote
		self.partnerTwoVote = partnerTwoVote
	}
}
