//
//  WatchContentView.swift
//  Pair
//
//  Created by Evan Best on 2026-05-02.
//

import SwiftUI

struct WatchContentView: View {
	@Environment(\.isSearching) private var isSearching
	let watchVM = WatchViewModel()

	var body: some View {
		if isSearching {
			MovieSearchResultsView(watchVM: watchVM)
		} else {
			WatchMainView(watchVM: watchVM)
		}
	}
}

#Preview {
	WatchContentView()
}
