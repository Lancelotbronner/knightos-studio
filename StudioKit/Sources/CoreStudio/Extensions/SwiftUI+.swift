//
//  SwiftUI+.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-12-04.
//

import SwiftUI

public extension View {

#if canImport(AppKit)
	/// Sets the system cursor when hovering over a view.
	///
	/// Apply the `contentShape` modifier before the `cursor` modifier for better compatability with custom views.
	/// - Parameter cursor: The cursor to set.
	func cursor(_ cursor: NSCursor) -> some View {
		onHover { ($0 ? cursor.push : cursor.pop)() }
	}
#endif

}
