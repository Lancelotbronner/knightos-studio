//
//  Bundle+.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-12-04.
//

import Foundation

public extension Bundle {

	var copyright: String? {
		object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String
	}

	var shortVersion: String? {
		object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
	}

	var build: String? {
		object(forInfoDictionaryKey: "CFBundleVersion") as? String
	}

	var channel: String? {
		object(forInfoDictionaryKey: "STUDIO_CHANNEL") as? String
	}

}
