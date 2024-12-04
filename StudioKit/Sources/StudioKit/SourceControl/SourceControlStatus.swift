//
//  SourceControlFile.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-06-22.
//

public struct SourceControlStatus {

	/// The state of a modification file.
	public var state: State

	/// Whether the file is staged for commit.
	public var staged: Bool

	public enum State {
		case modified
		case untracked
		case fileTypeChange
		case added
		case deleted
		case renamed
		case copied
		case updatedUnmerged
	}

}
