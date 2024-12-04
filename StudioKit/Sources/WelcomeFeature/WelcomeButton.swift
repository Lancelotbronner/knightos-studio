//
//  WelcomeButton.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-12-04.
//

import SwiftUI

public struct WelcomeButton: View {
	private let icon: Image
	private let title: Text
	private let action: () -> Void

	public init(_ title: Text, icon: Image, action: @escaping () -> Void) {
		self.icon = icon
		self.title = title
		self.action = action
	}

	public init(_ titleKey: LocalizedStringKey, systemIcon: String, action: @escaping () -> Void) {
		self.init(Text(titleKey), icon: Image(systemName: systemIcon), action: action)
	}

	public var body: some View {
		Button(action: action) {
			HStack(spacing: 7) {
				icon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(.secondary)
					.font(.system(size: 20))
					.frame(width: 24)
				title
					.font(.system(size: 13, weight: .semibold))
				Spacer()
			}
		}
		.buttonStyle(WelcomeButtonStyle())
	}
}

private struct WelcomeButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.contentShape(Rectangle())
			.padding(7)
			.frame(height: 36)
			.background(Color(.labelColor).opacity(configuration.isPressed ? 0.1 : 0.05))
			.clipShape(RoundedRectangle(cornerRadius: 8))
	}
}
