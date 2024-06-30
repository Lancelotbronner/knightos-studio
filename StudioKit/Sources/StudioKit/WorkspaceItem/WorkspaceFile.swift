//
//  WorkspaceFile.swift
//  
//
//  Created by Christophe Bronner on 2024-06-29.
//

import Foundation

public struct WorkspaceFile {

	public let url: URL

	@usableFromInline var _sourceControl: SourceControlStatus?
	@usableFromInline var _resourceValues: URLResourceValues?

	public init(at url: URL) throws {
		self.url = url
		_handle = File
	}

}
