//
//  WorkspaceDocument.swift
//  
//
//  Created by Christophe Bronner on 2024-06-26.
//

import SwiftUI
import UniformTypeIdentifiers

struct WorkspaceDocument : FileDocument {

	public static let readableContentTypes: [UTType] = [.directory]

	var workspace: Workspace?

	public init(configuration: ReadConfiguration) throws {

	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		configuration.existingFile ?? FileWrapper(directoryWithFileWrappers: [:])
	}

}
