//
//  ThumbnailView.swift
//  
//
//  Created by Christophe Bronner on 2024-06-22.
//

import SwiftUI

public struct ThumbnailView: View {
	private let file: WorkspaceItem

	public init(file: WorkspaceItem) {
		self.file = file
	}

	public var body: some View {
		// Based on settings and content type, select an appropriate icon
		QuicklookThumbnailView(file.url)
			.quicklookRepresentationTypes(.icon)
	}
}
