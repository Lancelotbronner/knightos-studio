//
//  Environment+Quicklook.swift
//  
//
//  Created by Christophe Bronner on 2024-06-22.
//

import SwiftUI
import QuickLookThumbnailing

extension EnvironmentValues {
	@Entry var quicklookRepresentationTypes = QLThumbnailGenerator.Request.RepresentationTypes.all
}

extension View {

	public func quicklookRepresentationTypes(_ value: QLThumbnailGenerator.Request.RepresentationTypes) -> some View {
		environment(\.quicklookRepresentationTypes, value)
	}

}
