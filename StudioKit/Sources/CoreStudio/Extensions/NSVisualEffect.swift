//
//  VisualEffect.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-12-04.
//

#if os(macOS)
import SwiftUI

/// A SwiftUI Wrapper for `NSVisualEffectView`
///
/// ## Usage
/// ```swift
/// NSVisualEffect(material: .headerView, blendingMode: .withinWindow)
/// ```
public struct NSVisualEffect: NSViewRepresentable {
	private let material: NSVisualEffectView.Material
	private let blendingMode: NSVisualEffectView.BlendingMode
	private let emphasized: Bool

	/// Initializes the
	/// [`NSVisualEffectView`](https://developer.apple.com/documentation/appkit/nsvisualeffectview)
	/// with a
	/// [`Material`](https://developer.apple.com/documentation/appkit/nsvisualeffectview/material) and
	/// [`BlendingMode`](https://developer.apple.com/documentation/appkit/nsvisualeffectview/blendingmode)
	///
	/// By setting the
	/// [`emphasized`](https://developer.apple.com/documentation/appkit/nsvisualeffectview/1644721-isemphasized)
	/// flag, the emphasized state of the material will be used if available.
	///
	/// - Parameters:
	///   - material: The material to use. Defaults to `.headerView`.
	///   - blendingMode: The blending mode to use. Defaults to `.withinWindow`.
	///   - emphasized:A Boolean value indicating whether to emphasize the look of the material. Defaults to `false`.
	public init(
		_ material: NSVisualEffectView.Material = .headerView,
		blendingMode: NSVisualEffectView.BlendingMode = .withinWindow,
		emphasized: Bool = false
	) {
		self.material = material
		self.blendingMode = blendingMode
		self.emphasized = emphasized
	}

	public func makeNSView(context: Context) -> NSVisualEffectView {
		let view = NSVisualEffectView()
		view.material = material
		view.blendingMode = blendingMode
		view.isEmphasized = emphasized
		view.state = .followsWindowActiveState
		return view
	}

	public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
		nsView.material = material
		nsView.blendingMode = blendingMode
	}

	/// Returns the system selection style as an ``EffectView`` if the `condition` is met.
	/// Otherwise it returns `Color.clear`
	///
	/// - Parameter condition: The condition of when to apply the background. Defaults to `true`.
	/// - Returns: A View
	@ViewBuilder
	public static func selectionBackground(_ condition: Bool = true) -> some View {
		if condition {
			NSVisualEffect(.selection, blendingMode: .withinWindow, emphasized: true)
		} else {
			Color.clear
		}
	}
}

#endif
