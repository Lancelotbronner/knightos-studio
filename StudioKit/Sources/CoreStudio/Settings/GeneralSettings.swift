//
//  GeneralSettings.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-12-04.
//

/// The reopen behaviour of the app
public enum ReopenBehaviour: String, Codable {
	public static let key = "settings.reopen-behaviour"

	/// On restart the app will show the welcome screen
	case welcome
	/// On restart the app will show an open panel
	case openPanel
	/// On restart a new empty document will be created
	case newDocument
	/// On restart nothing will happen
	case nothing

	public var isWelcomeSceneShownOnLaunch: Bool {
		get { self == .welcome }
		set { self = newValue ? .welcome : (isWelcomeSceneShownOnLaunch ? .nothing : self) }
	}

}
