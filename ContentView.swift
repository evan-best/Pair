//
//  ContentView.swift
//  Pair
//
//  Created by Evan Best on 2026-04-22.
//

import SwiftData
import SwiftUI

enum Tabs {
	case watch
	case cook
	case memories
	case list
}

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	@State private var selectedTab: Tabs = .watch

	var body: some View {
		TabView(selection: $selectedTab) {
			Tab("Watch", systemImage: "play", value: .watch) {
				WatchContentView()
			}
			Tab("Cook", systemImage: "play", value: .cook) {
				CookView()
			}
			Tab("Memories", systemImage: "play", value: .memories) {
				MemoriesView()
			}
			Tab("List", systemImage: "play", value: .list) {
				ListView()
			}
		}
	}
}

#Preview {
	ContentView()
}
