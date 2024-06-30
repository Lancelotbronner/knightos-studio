//
//  Package.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-06-22.
//

import Foundation

@Observable
public final class Package {

	public let rootURL: URL

	public init(at rootURL: URL) {
		self.rootURL = rootURL
	}

}
