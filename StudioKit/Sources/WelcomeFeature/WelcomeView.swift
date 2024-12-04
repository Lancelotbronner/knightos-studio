//
//  WelcomeView.swift
//  CodeEditModules/WelcomeModule
//
//  Created by Ziyuan Zhao on 2022/3/18.
//

import SwiftUI
import CoreStudio

struct WelcomeView: View {
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.controlActiveState) private var controlActiveState
	@Environment(\.openDocument) private var openDocument
	@Environment(\.newDocument) private var newDocument
	@Environment(\.dismissWindow) private var dismissWindow
	@Environment(\.presentClone) private var presentClone
	@AppStorage(ReopenBehaviour.key) private var reopenBehavior = ReopenBehaviour.welcome

	var body: some View {
		ZStack(alignment: .topLeading) {
			VStack(spacing: 0) {
				ZStack {
					if colorScheme == .dark {
						Rectangle()
							.frame(width: 104, height: 104)
							.foregroundColor(.accentColor)
							.clipShape(RoundedRectangle(cornerRadius: 24))
							.blur(radius: 64)
							.opacity(0.5)
					}
					Studio.icon
						.resizable()
						.frame(width: 128, height: 128)
				}
				.padding(.top, 32)

				Text("KnightOS Studio")
					.font(.system(size: 36, weight: .bold))

				Button("Version \(Studio.version)", action: copyInformation)
					.buttonStyle(.link)
					.textSelection(.enabled)
					.foregroundColor(.secondary)
					.font(.system(size: 13.5))
					.cursor(.pointingHand)
					.onTapGesture(perform: copyInformation)
					.help("Copy System Information to Clipboard")

				VStack(alignment: .leading, spacing: 8) {
					actions
				}
				.padding(.top, 40)

				Spacer()
			}
			.padding(EdgeInsets(top: 20, leading: 56, bottom: 16, trailing: 56))
			.frame(width: 460)
			.background(
				colorScheme == .dark
				? Color.black.opacity(0.2)
				: Color.white.opacity(controlActiveState == .inactive ? 1.0 : 0.5))
			.background(NSVisualEffect(.underWindowBackground, blendingMode: .behindWindow))

			Button("Close", systemImage: "xmark.circle.fill") {
				dismissWindow()
			}
			.buttonStyle(WelcomeCloseButtonStyle())
		}
	}

	@ViewBuilder
	private var actions: some View {
		WelcomeButton("Create New Project...", systemIcon: "plus.square") {
			//TODO: Show project creation window
			newDocument(contentType: .kworkspace)
			dismissWindow()
		}
		WelcomeButton("Clone Git Repository...", systemIcon: "square.and.arrow.down.on.square") {
			presentClone()
		}
		WelcomeButton("Open Existing Project...", systemIcon: "folder") {
			//TODO: Present fileImporter to select url
//						openDocument(at: url)
			dismissWindow()
		}
	}

	/// Get program and operating system information
	private func copyInformation() {
		let info = """
		Studio: \(Studio.version)
		macOS: \(Studio.systemVersion)
		Xcode: \(Studio.xcodeVersion ?? "")
		"""
		let pasteboard = NSPasteboard.general
		pasteboard.clearContents()
		pasteboard.setString(info, forType: .string)
	}

}

private struct WelcomeCloseButtonStyle: ButtonStyle {
	@State private var isHovering = false

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.labelStyle(.iconOnly)
			.foregroundColor(Color(isHovering ? .secondaryLabelColor : .tertiaryLabelColor))
			.onHover { hover in
				withAnimation(.linear(duration: 0.15)) {
					isHovering = hover
				}
			}
			.padding(10)
			.transition(.opacity.animation(.easeInOut(duration: 0.25)))
	}
}
