//
//  Workspace.swift
//  
//
//  Created by Christophe Bronner on 2024-06-22.
//

import Foundation
import Combine

@Observable
public final class Workspace {

	public let url: URL

	@inlinable public init(at url: URL) {
		self.url = url
	}

}
