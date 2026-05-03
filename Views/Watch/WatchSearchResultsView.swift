//
//  WatchSearchResultsView.swift
//  Pair
//
//  Created by Evan Best on 2026-05-02.
//

import SwiftUI

struct MovieSearchResultsView: View {
	let watchVM: WatchViewModel
	var body: some View {
		Text("Movie Search Results")
	}
}

#Preview {
	MovieSearchResultsView(watchVM: WatchViewModel())
}
