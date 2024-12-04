//
//  Workspace.swift
//  Studio
//
//  Created by Christophe Bronner on 2024-06-26.
//

public struct Workspace: Sendable, Codable {
	public static let version = 1

	public init() { }

	public private(set) var version = Workspace.version

	public var contents: [WorkspaceContent] = []
}

public enum WorkspaceContent: Sendable, Codable {
	/// Uses the current document URL
	case document
	/// Points to a local folder
	case folder(WorkspaceContent.FolderItem)
}

extension WorkspaceContent {
	public struct FolderItem: Sendable, Codable {
		public let path: String
	}
}
