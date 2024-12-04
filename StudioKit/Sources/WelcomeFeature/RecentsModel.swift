//
//  RecentsModel.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-12-04.
//

import SwiftUI
import CoreSpotlight

@Observable @MainActor
public final class RecentsModel {
	public static let shared = RecentsModel()

	public private(set) var urls: [URL]

	private static let defaultsKey = "recents"
	private static let spotlightDomain = "org.knightos.studio.recent"

	private init() {
		let paths = UserDefaults.standard.array(forKey: Self.defaultsKey) as? [String] ?? []
		urls = paths.compactMap(URL.init(string:))
	}

	func documentOpened(at url: URL) {
		let i = _urls.firstIndex(of: url)
		// move or insert to front
		if let i {
			urls.move(fromOffsets: IndexSet(integer: i), toOffset: 0)
		} else {
			urls.insert(url, at: 0)
		}

		trimExcessRecents()
		donate([url])
		synchronizeDocumentController()
		persist()
	}

	/// Remove all paths in the set.
	/// - Parameter paths: The paths to remove.
	/// - Returns: The remaining urls in the recent projects list.
	func remove(_ urls: Set<URL>) {
		self.urls.removeAll(where: urls.contains)

		let paths = urls.map { $0.path() }
		CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: paths)

		synchronizeDocumentController()
		persist()
	}

	func removeAll() {
		urls.removeAll()
		CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [Self.spotlightDomain])
		NSDocumentController.shared.clearRecentDocuments(nil)
		UserDefaults.standard.setValue(nil, forKey: Self.defaultsKey)

	}

	/// Donates all recent URLs to Core Search, making them searchable in Spotlight
	private func donate(_ urls: [URL]) {
		let searchableItems = urls.map { entity in
			let attributeSet = CSSearchableItemAttributeSet(contentType: .content)
			attributeSet.title = entity.lastPathComponent
			attributeSet.contentURL = entity
			attributeSet.relatedUniqueIdentifier = entity.path()
			return CSSearchableItem(
				uniqueIdentifier: entity.path(),
				domainIdentifier: Self.spotlightDomain,
				attributeSet: attributeSet)
		}
		CSSearchableIndex.default().indexSearchableItems(searchableItems) { error in
			if let error = error {
				print(error)
			}
		}
	}

	private func trimExcessRecents() {
		let difference = _urls.count - NSDocumentController.shared.maximumRecentDocumentCount
		guard difference > 0 else { return }

		let paths = _urls.suffix(difference).map { $0.path() }
		CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: paths)
		urls.removeLast(difference)
	}

	/// Syncs AppKit's recent documents list with ours, keeping the dock menu and other lists up-to-date.
	private func synchronizeDocumentController() {
		NSDocumentController.shared.clearRecentDocuments(nil)
		for url in _urls.prefix(NSDocumentController.shared.maximumRecentDocumentCount) {
			NSDocumentController.shared.noteNewRecentDocumentURL(url)
		}
	}

	private func persist() {
		UserDefaults.standard.setValue(urls.map { $0.path() }, forKey: Self.defaultsKey)
	}

}
