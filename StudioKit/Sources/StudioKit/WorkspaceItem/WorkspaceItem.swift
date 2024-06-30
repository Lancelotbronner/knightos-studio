//
//  WorkspaceItem.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-06-22.
//

import Foundation
import Combine
import UniformTypeIdentifiers
import OSLog

@Observable
public final class WorkspaceItem : Identifiable, Hashable {

	/// The URL of the file.
	public let url: URL

	@usableFromInline var _sourceControl: SourceControlStatus?

	@ObservationIgnored
	@usableFromInline lazy var _resourceValues = resourceValues()

	@usableFromInline weak var _parent: WorkspaceItem?

	/// Creates a workspace file pointing at a real on-disk location.
	/// - Parameter url: The URL of the on-disk file.
	@inlinable public init(at url: URL) {
		self.url = url
	}

	@usableFromInline func resourceValues() -> URLResourceValues {
		do {
			return try url.resourceValues(forKeys: [.isDirectoryKey, .contentTypeKey])
		} catch {
			let url = url
			Logger.workspace.warning("Failed to retrieve content type of \(url): \(error)")
			return URLResourceValues()
		}
	}

	@inlinable public static func == (lhs: WorkspaceItem, rhs: WorkspaceItem) -> Bool {
		lhs.id == rhs.id
	}

	@inlinable public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

}

extension WorkspaceItem {

	/// The parent of this file or `nil` if it doesn't have any.
	public var parent: WorkspaceItem? {
		_parent
	}

	/// The source control status, if loaded.
	public var sourceControl: SourceControlStatus? {
		_sourceControl
	}

}

//MARK: - Attributes

extension WorkspaceItem {

	/// The name of the file.
	@inlinable public var name: String {
		url.lastPathComponent.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	/// Returns a boolean that is true if the resource represented by this object is a directory.
	@inlinable public var isFolder: Bool {
		_resourceValues.isDirectory == true
	}

	/// The content type of the file, if known.
	@inlinable public var contentType: UTType? {
		_resourceValues.contentType
	}

}

//MARK: - Actions

#if canImport(AppKit)
import AppKit

extension WorkspaceItem {

	/// Allows the user to view the file or folder in the finder application
	public func showInFinder() {
		NSWorkspace.shared.activateFileViewerSelecting([url])
	}

	/// Allows the user to launch the file or folder as it would be in finder
	public func openWithExternalEditor() {
		NSWorkspace.shared.open(url)
	}

}
#endif
