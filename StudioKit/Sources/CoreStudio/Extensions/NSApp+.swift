//
//  NSApp+.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-12-04.
//

import AppKit

private extension NSWindow {
	var id: String {
		identifier?.rawValue ?? ""
	}
}

public extension NSApplication {

	func firstWindow(_ id: String) -> NSWindow? {
		windows.first { $0.id == id }
	}

	func filterWindows(_ ids: Set<String>) -> [NSWindow] {
		windows.filter { ids.contains($0.id) }
	}

}
