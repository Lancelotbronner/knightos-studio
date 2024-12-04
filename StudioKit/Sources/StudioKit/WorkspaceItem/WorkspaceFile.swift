//
//  WorkspaceFile.swift
//  
//
//  Created by Christophe Bronner on 2024-06-29.
//

import Foundation

/// Represents a physical file as part of a workspace item.
public struct WorkspaceFile {

	public let url: URL

	@usableFromInline var _sourceControl: SourceControlStatus?
	@usableFromInline var _resourceValues: URLResourceValues?

	public init(at url: URL) {
		self.url = url
	}

}
