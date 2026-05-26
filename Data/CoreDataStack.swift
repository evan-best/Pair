//
//  CoreDataStack.swift
//  Pair
//
//  Created by Evan Best on 2026-05-26.
//

import Foundation
import CoreData
import CloudKit

final class CoreDataStack {
	static let shared = CoreDataStack()

	let containerIdentifier = "iCloud.com.evan-best.Pair"
	let container: NSPersistentCloudKitContainer

	private(set) var privateStore: NSPersistentStore?
	private(set) var sharedStore: NSPersistentStore?

	var viewContext: NSManagedObjectContext {
		container.viewContext
	}

	private init() {
		container = NSPersistentCloudKitContainer(name: "Pair")

		let baseURL = NSPersistentContainer.defaultDirectoryURL()

		// Private store (this users data)
		let privateDesc = NSPersistentStoreDescription(url: baseURL.appendingPathComponent("private.sqlite"))
		let privateOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
		privateOptions.databaseScope = .private
		privateDesc.cloudKitContainerOptions = privateOptions
		privateDesc.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
		privateDesc.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

		// Shared store (data shared to this user)
		guard let sharedDesc = privateDesc.copy() as? NSPersistentStoreDescription else {
			fatalError("Failed to copy private store description")
		}
		sharedDesc.url = baseURL.appendingPathComponent("shared.sqlite")
		let sharedOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
		sharedOptions.databaseScope = .shared
		sharedDesc.cloudKitContainerOptions = sharedOptions

		container.persistentStoreDescriptions = [privateDesc, sharedDesc]

		container.loadPersistentStores { [weak self] description, error in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
			guard let scope = description.cloudKitContainerOptions?.databaseScope,
				  let url = description.url else { return }
			let store = self?.container.persistentStoreCoordinator.persistentStore(for: url)
			if scope == .private {
				self?.privateStore = store
			} else if scope == .shared {
				self?.sharedStore = store
			}
		}

		container.viewContext.automaticallyMergesChangesFromParent = true
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
	}
}
