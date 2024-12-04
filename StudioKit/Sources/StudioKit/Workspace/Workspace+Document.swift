//
//  Workspace+Document.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-12-04.
//

import SwiftUI
import UniformTypeIdentifiers
import CoreStudio

extension Workspace : FileDocument {

	public static let readableContentTypes: [UTType] = [.kworkspace, .folder]
	public static let writableContentTypes: [UTType] = [.kworkspace]

	private struct Essentials: Codable {
		var version: Int
	}

	public init(configuration: ReadConfiguration) throws {
		// Detect transient workspaces
		if configuration.file.isDirectory {
			self = Workspace()
			contents.append(.document)
			return
		}

		// Parse workspace files
		guard configuration.file.isRegularFile else {
			throw CocoaError(.fileReadCorruptFile)
		}
		let data = configuration.file.regularFileContents ?? Data()
		let essentials = try JSONDecoder().decode(Essentials.self, from: data)

		if Workspace.version != essentials.version {
			throw CocoaError(.fileReadUnsupportedScheme, userInfo: [NSLocalizedDescriptionKey: "Unknown workspace version."])
		}

		self = try JSONDecoder().decode(Self.self, from: data)
	}

	public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let data = try JSONEncoder().encode(self)
		return FileWrapper(regularFileWithContents: data)
	}

}
