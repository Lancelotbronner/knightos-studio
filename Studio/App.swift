//
//  Studio_z80App.swift
//  Studio z80
//
//  Created by Christophe Bronner on 2024-03-17.
//

import SwiftUI
import WelcomeFeature
import StudioKit

@main struct StudioApp: App {
	var body: some Scene {
		WelcomeScene()
		
		WorkspaceScene()
	}
}
