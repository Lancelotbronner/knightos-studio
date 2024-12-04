//
//  WelcomeScene.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-12-04.
//

import SwiftUI

public struct WelcomeScene: Scene {
	static let id = "welcome"

	public init() { }

	public var body: some Scene {
		Window("Welcome to KnightOS Studio", id: WelcomeScene.id) {
			WelcomeContentView()
				.frame(width: 740, height: 432)
				.windowMinimizeBehavior(.disabled)
				.windowFullScreenBehavior(.disabled)
				.onAppear {
					guard let window = NSApp.firstWindow(WelcomeScene.id) else {
						preconditionFailure("Failed to find Welcome window")
					}
					window.standardWindowButton(.closeButton)?.isHidden = true
					window.standardWindowButton(.miniaturizeButton)?.isHidden = true
					window.standardWindowButton(.zoomButton)?.isHidden = true
				}
		}
		//TODO: Maybe use WindowVisibilityToggle instead?
		.keyboardShortcut("1", modifiers: [.shift, .command])
		.windowBackgroundDragBehavior(.enabled)
		.windowResizability(.contentSize)
		.defaultPosition(.center)
		.windowStyle(.hiddenTitleBar)
	}
}

private struct WelcomeContentView: View {
	var body: some View {
		HStack(spacing: 0) {
			WelcomeView()
			RecentsView()
				.frame(width: 280)
		}
		.edgesIgnoringSafeArea(.top)
		//TODO: Support dropping files
	}
}

//MARK: - Open Action

public struct OpenWelcomeAction {
	let openWindow: OpenWindowAction

	@MainActor
	public func callAsFunction() {
		openWindow(id: WelcomeScene.id)
	}
}

public extension EnvironmentValues {
	var openWelcome: OpenWelcomeAction {
		OpenWelcomeAction(openWindow: openWindow)
	}
}
