//
//  TMDBImageView.swift
//  Pair
//
//  Created by Evan Best on 2026-05-02.
//

import SwiftUI

struct TMDBImageView: View {
    let path: String?
    let size: TMDBImageSize
    let contentMode: ContentMode

    var body: some View {
        // Drive layout from a flexible base so the loaded image's intrinsic
        // size can't push the parent's frame around.
        Color.clear
            .overlay {
                AsyncImage(url: Self.url(for: path, size: size)) { image in
                    configuredImage(image)
                } placeholder: {
                    Color.clear
                }
            }
            .clipped()
    }

    @ViewBuilder
    private func configuredImage(_ image: Image) -> some View {
        switch contentMode {
        case .fit:
            image
                .resizable()
                .scaledToFit()
        case .fill:
            image
                .resizable()
                .scaledToFill()
        }
    }
}

extension TMDBImageView {
    static func url(for path: String?, size: TMDBImageSize) -> URL? {
        guard let trimmedPath = path?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmedPath.isEmpty else {
            return nil
        }

        return URL(string: "https://image.tmdb.org/t/p/\(size.rawValue)\(trimmedPath)")
    }
}

enum TMDBImageSize: String {
    case poster = "w342"
    case hero = "w780"
	case backdrop = "w1280"
	case logo = "w500"
}

actor TMDBImagePrefetcher {
    static let shared = TMDBImagePrefetcher()

    private var prefetchedURLs = Set<URL>()

    func prefetch(paths: [String?], size: TMDBImageSize) async {
        for path in paths {
			guard let url = await TMDBImageView.url(for: path, size: size) else {
                continue
            }

            if prefetchedURLs.contains(url) {
                continue
            }

            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            if URLCache.shared.cachedResponse(for: request) != nil {
                prefetchedURLs.insert(url)
                continue
            }

            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                prefetchedURLs.insert(url)
            } catch {
                continue
            }
        }
    }
}
