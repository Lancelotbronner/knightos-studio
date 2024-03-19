//
//  ContentView.swift
//  Studio z80
//
//  Created by Christophe Bronner on 2024-03-17.
//

import SwiftUI
import Z80

struct ContentView: View {
	@State private var z80 = ObservableZ80()

	var body: some View {
		RegistersView()
			.environment(z80)
			.padding()
			.toolbar {
				Button("Step") {
					z80.step()
				}
			}
	}
}

#Preview {
    ContentView()
}
