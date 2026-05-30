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
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(\.managedObjectContext, stack.viewContext)
        }
    }
}
