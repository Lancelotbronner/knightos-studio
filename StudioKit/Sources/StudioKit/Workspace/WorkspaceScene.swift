//
//  WorkspaceScene.swift
//  StudioKit
//
//  Created by Christophe Bronner on 2024-12-04.
//

import SwiftUI
import CoreStudio

public struct WorkspaceScene: Scene {
	public init() { }

	public var body: some Scene {
		DocumentGroup(newDocument: Workspace()) { configuration in
			
		}
	}
}
