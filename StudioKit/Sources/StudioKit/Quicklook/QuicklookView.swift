//
//  PreviewView.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-06-22.
//

import SwiftUI

/// A view for previewing any kind of file.
///
/// ```swift
/// QuicklookView(fileURL)
/// ```
///
/// If the file cannot be previewed, a file icon thumbnail is shown instead.
public struct QuicklookView: View {

	/// URL of the file to preview. You can pass in any file type.
	private let fileURL: URL
	
	/// Creates a quicklook view pointing to a specific file.
	/// - Parameter fileURL: The file to quicklook.
	public init(_ fileURL: URL) {
		self.fileURL = fileURL
	}

	public var body: some View {
		QuicklookRepresentable(fileURL: fileURL)
	}
}

#Preview {
	QuicklookView(URL(fileURLWithPath: #filePath))
}

struct QuicklookRepresentable {
	let fileURL: URL
}

#if canImport(AppKit)
import QuickLookUI

extension QuicklookRepresentable: NSViewRepresentable {

	func makeNSView(context: Context) -> QLPreviewView {
		let view = QLPreviewView()
		view.previewItem = fileURL as any QLPreviewItem
		return view
	}

	func updateNSView(_ view: QLPreviewView, context: Context) {
		view.previewItem = fileURL as any QLPreviewItem
	}

}
#elseif canImport(UIKit)
import QuickLook

extension QuicklookRepresentable: UIViewControllerRepresentable {

	final class Coordinator: NSObject, QLPreviewControllerDataSource {
		var fileURL: URL

		init(fileURL: URL) {
			self.fileURL = fileURL
		}

		func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
			1
		}
		
		func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> any QLPreviewItem {
			fileURL as any QLPreviewItem
		}
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(fileURL: fileURL)
	}

	func makeUIViewController(context: Context) -> QLPreviewController {
		let controller = QLPreviewController()
		controller.dataSource = context.coordinator
		return controller
	}

	func updateUIViewController(_ controller: QLPreviewController, context: Context) {
		if fileURL != context.coordinator.fileURL {
			context.coordinator.fileURL = fileURL
			controller.reloadData()
		}
	}

}
#endif
