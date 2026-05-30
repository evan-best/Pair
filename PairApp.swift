//
//  PairApp.swift
//  Pair
//
//  Created by Evan Best on 2026-04-22.
//

import SwiftUI
import CoreData

@main
struct PairApp: App {
	let stack = CoreDataStack.shared

	init() {
		URLCache.shared = URLCache(
			memoryCapacity: 50 * 1024 * 1024,
			diskCapacity: 500 * 1024 * 1024
		)
	}

    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(\.managedObjectContext, stack.viewContext)
        }
    }
}
