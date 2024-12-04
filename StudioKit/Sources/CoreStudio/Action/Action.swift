//
//  Action.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-12-04.
//

import SwiftUI

public struct Action {
	fileprivate var isPresented = Binding<Bool>.constant(false)

	public func callAsFunction() {
		isPresented.wrappedValue = true
	}
}

public struct ActionOf<Item: Identifiable> {
	fileprivate var item = Binding<Item?>.constant(nil)

	public func callAsFunction(_ item: Item) {
		self.item.wrappedValue = item
	}
}

//MARK: - Sheet Modifiers

public extension View {

	func sheet<Content: View>(
		action: WritableKeyPath<EnvironmentValues, Action>,
		onDismiss: (() -> Void)? = nil,
		@ViewBuilder content: @escaping () -> Content
	) -> some View {
		modifier(SheetActionModifier(keyPath: action, onDismiss: onDismiss, makeContent: content))
	}
	
	func sheet<Item: Identifiable, Content: View>(
		action: WritableKeyPath<EnvironmentValues, ActionOf<Item>>,
		onDismiss: (() -> Void)? = nil,
		@ViewBuilder content: @escaping (Item) -> Content
	) -> some View {
		modifier(SheetActionOfModifier(keyPath: action, onDismiss: onDismiss, makeContent: content))
	}

}

private struct SheetActionModifier<SheetContent: View>: ViewModifier {
	@State private var isPresented = false
	let keyPath: WritableKeyPath<EnvironmentValues, Action>
	let onDismiss: (() -> Void)?
	let makeContent: () -> SheetContent

	func body(content: Content) -> some View {
		content
			.sheet(isPresented: $isPresented, onDismiss: onDismiss, content: makeContent)
			.environment(keyPath.appending(path: \.isPresented), $isPresented)
	}
}

private struct SheetActionOfModifier<Item: Identifiable, SheetContent: View>: ViewModifier {
	@State private var item: Item?
	let keyPath: WritableKeyPath<EnvironmentValues, ActionOf<Item>>
	let onDismiss: (() -> Void)?
	let makeContent: (Item) -> SheetContent

	func body(content: Content) -> some View {
		content
			.sheet(item: $item, onDismiss: onDismiss, content: makeContent)
			.environment(keyPath.appending(path: \.item), $item)
	}
}
