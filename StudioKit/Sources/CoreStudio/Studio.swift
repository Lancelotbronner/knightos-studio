//
//  Studio.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-12-04.
//

import SwiftUI

public enum Studio {

	public static let shortVersion = Bundle.main.shortVersion ?? ""
	public static let channel = Bundle.main.channel ?? ""
	public static let build = Bundle.main.build ?? ""

	@MainActor public static let icon: Image = {
#if os(macOS)
		return Image(nsImage: NSApp.applicationIconImage)
#endif
	}()

	public static let version: String = {
		var description = shortVersion
		if !channel.isEmpty {
			description.append(" \(channel)")
		}
		if !build.isEmpty {
			description.append(" (\(build))")
		}
		return description
	}()

	public static let systemVersion: String = {
		let url = URL(fileURLWithPath: "/System/Library/CoreServices/SystemVersion.plist")
		guard
			let info = NSDictionary(contentsOf: url),
			let version = info["ProductUserVisibleVersion"],
			let build = info["ProductBuildVersion"]
		else { return ProcessInfo.processInfo.operatingSystemVersionString }
		return "\(version) (\(build))"
	}()

	public static let xcodeVersion: String? = {
		guard
			let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.dt.Xcode"),
			let bundle = Bundle(url: url),
			let infoDict = bundle.infoDictionary,
			let version = infoDict["CFBundleShortVersionString"] as? String,
			let buildURL = URL(string: "\(url)Contents/version.plist"),
			let buildDict = try? NSDictionary(contentsOf: buildURL, error: ()),
			let build = buildDict["ProductBuildVersion"]
		else { return nil }
		return "\(version) (\(build))"
	}()

}
