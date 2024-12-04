//
//  RecentsView.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-12-04.
//

import SwiftUI
import CoreSpotlight
import CoreStudio

struct RecentsView: View {
	@Environment(\.openDocument) private var openDocument
	@Environment(\.dismissWindow) private var dismissWindow
	@State private var selection: Set<URL>
	private let model = RecentsModel.shared

	init() {
		selection = Set(model.urls.prefix(1))
	}

	var body: some View {
		List(selection: $selection) {
			ForEach(model.urls, id: \.self) {
				RecentCell(url: $0)
			}
		}
		.listStyle(.sidebar)
		.contextMenu(forSelectionType: URL.self) { items in
			switch items.count {
			case 0:
				EmptyView()
			default:
				Button("Show in Finder") {
					NSWorkspace.shared.activateFileViewerSelecting(Array(items))
				}
				Button("Copy \(items.count) paths") {
					let pasteBoard = NSPasteboard.general
					pasteBoard.clearContents()
					pasteBoard.writeObjects(selection.map(\.relativePath) as [NSString])
				}
				Button("Remove from Recents") {
					model.remove(selection)
				}
			}
		} primaryAction: {
			openDocuments($0)
		}
		.onCopyCommand {
			selection.map { NSItemProvider(object: $0.path(percentEncoded: false) as NSString) }
		}
		.onDeleteCommand {
			model.remove(selection)
		}
		.background(NSVisualEffect(.underWindowBackground, blendingMode: .behindWindow))
		.background {
			//TODO: Test if I can just make the items the button
			Button("") {
				openDocuments(selection)
			}
			.keyboardShortcut(.defaultAction)
			.hidden()
		}
		.overlay {
			if model.urls.isEmpty {
				Text("No Recent Projects")
					.font(.body)
					.foregroundColor(.secondary)
			}
		}
	}

	private func openDocuments(_ urls: some Sequence<URL>) {
		Task {
			for item in urls {
				do {
					try await openDocument(at: item)
				} catch { }
			}
		}
		dismissWindow()
	}

}

private struct RecentCell: View {
	let url: URL

	var body: some View {
		HStack(spacing: 8) {
			icon
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 32, height: 32)
			VStack(alignment: .leading) {
				Text(title)
					.foregroundColor(.primary)
					.font(.system(size: 13, weight: .semibold))
					.lineLimit(1)
				Text(subtitle)
					.foregroundColor(.secondary)
					.font(.system(size: 11))
					.lineLimit(1)
					.truncationMode(.head)
			}
		}
		.frame(height: 36)
		.contentShape(Rectangle())
	}

	private var icon: Image {
		let path = url.path(percentEncoded: false)
		let nsimage = NSWorkspace.shared.icon(forFile: path)
		return Image(nsImage: nsimage)
	}

	private var title: String {
		url.lastPathComponent
	}

	private var subtitle: String {
		var path = url.deletingLastPathComponent().path(percentEncoded: false)
		path = (path as NSString).abbreviatingWithTildeInPath
		return path
	}

}
