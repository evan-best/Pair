//
//  WatchContentView.swift
//  Pair
//
//  Created by Evan Best on 2026-05-02.
//

import SwiftUI

struct WatchContentView: View {
	@Environment(\.isSearching) private var isSearching
	@State private var watchVM = WatchViewModel()

	var body: some View {
		NavigationStack {
			Group {
				if isSearching || !watchVM.searchTerm.isEmpty {
					MovieSearchResultsView(watchVM: watchVM)
				} else {
					WatchMainView(watchVM: watchVM)
				}
			}
			.navigationTitle("Watch")
		}
		.searchable(text: $watchVM.searchTerm, prompt: "Search movies")
		.autocorrectionDisabled()
		.textInputAutocapitalization(.never)
		.onSubmit(of: .search) {
			Task {
				await watchVM.search()
			}
		}
		.onChange(of: watchVM.searchTerm) { _, newValue in
			if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
				watchVM.searchResults = []
				watchVM.error = nil
			}
		}
	}
}

#Preview {
	WatchContentView()
}
