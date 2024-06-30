//
//  OSLog+.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-06-22.
//

import OSLog

extension Logger {

	public static func knightos(category: String) -> Logger {
		Logger(subsystem: "org.knightos.studio", category: category)
	}

	public static let workspace = knightos(category: "Workspace")

}
