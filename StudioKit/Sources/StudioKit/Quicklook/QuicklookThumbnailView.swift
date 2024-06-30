//
//  QuicklookThumbnailView.swift
//  
//
//  Created by Christophe Bronner on 2024-06-22.
//

import SwiftUI
import QuickLookThumbnailing
import OSLog

public struct QuicklookThumbnailView: View {
	@Environment(\.displayScale) private var displayScale
	@Environment(\.quicklookRepresentationTypes) private var quicklookRepresentationTypes
	@State private var request: QLThumbnailGenerator.Request?
	@State private var thumbnail: Image
	private let fileURL: URL

	public init(_ fileURL: URL, fallback: Image = Image(systemName: "doc.fill")) {
		self.fileURL = fileURL
		_thumbnail = State(initialValue: fallback)
	}

	private func generate(in proxy: GeometryProxy) async {
		let request = QLThumbnailGenerator.Request(fileAt: fileURL, size: proxy.size, scale: displayScale, representationTypes: quicklookRepresentationTypes)
		self.request = request

		QLThumbnailGenerator.shared.generateRepresentations(for: request) { representation, type, error in
			guard !Task.isCancelled else {
				QLThumbnailGenerator.shared.cancel(request)
				return
			}

			let fileURL = fileURL
			if let error {
				Logger.workspace.warning("Failed to generate thumbnail for \(fileURL): \(error)")
				return
			}
			guard let representation else {
				Logger.workspace.warning("Failed to generate thumbnail for \(fileURL) with an unknown error")
				return
			}

			DispatchQueue.main.async {
#if canImport(AppKit)
				self.thumbnail = Image(nsImage: representation.nsImage)
#elseif canImport(UIKit)
				self.thumbnail = Image(uiImage: representation.uiImage)
#endif
			}
		}
	}

	private func cancel() {
		guard let request else { return }
		QLThumbnailGenerator.shared.cancel(request)
	}

	public var body: some View {
		GeometryReader { proxy in
			thumbnail
				.resizable()
				.aspectRatio(contentMode: .fit)
				.onDisappear(perform: cancel)
				.task {
					print(proxy.size)
					await generate(in: proxy)
				}
		}
	}
}

#Preview {
	let url = URL(fileURLWithPath: #filePath)
	return HStack {
		QuicklookThumbnailView(url)
			.quicklookRepresentationTypes(.icon)
		QuicklookThumbnailView(url)
			.quicklookRepresentationTypes(.lowQualityThumbnail)
		QuicklookThumbnailView(url)
			.quicklookRepresentationTypes(.thumbnail)

	}
	.padding()
}
