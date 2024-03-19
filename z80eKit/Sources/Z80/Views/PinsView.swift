//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-03-18.
//

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 14, *)
public struct PinsView: View {
	@Environment(ObservableZ80.self) private var z80: ObservableZ80

	public init() { }

	public var body: some View {
		HStack(alignment: .top) {
			VStack(alignment: .trailing) {
				Toggle("D0", isOn: .constant(z80.data.bits[0]))
				Toggle("D1", isOn: .constant(z80.data.bits[1]))
				Toggle("D2", isOn: .constant(z80.data.bits[2]))
				Toggle("D3", isOn: .constant(z80.data.bits[3]))
				Toggle("D4", isOn: .constant(z80.data.bits[4]))
				Toggle("D5", isOn: .constant(z80.data.bits[5]))
				Toggle("D6", isOn: .constant(z80.data.bits[6]))
				Toggle("D7", isOn: .constant(z80.data.bits[7]))
				Toggle("M1", isOn: .constant(z80.control.contains(.m1)))
				Toggle("MREQ", isOn: .constant(z80.control.contains(.mreq)))
				Toggle("IORQ", isOn: .constant(z80.control.contains(.iorq)))
				Toggle("RD", isOn: .constant(z80.control.contains(.read)))
				Toggle("WR", isOn: .constant(z80.control.contains(.wr)))
				Toggle("RFSH", isOn: .constant(z80.control.contains(.rfsh)))
				Toggle("HALT", isOn: .constant(z80.control.contains(.halt)))
				Toggle("INT", isOn: .constant(z80.control.contains(.int)))
				Toggle("NMI", isOn: .constant(z80.control.contains(.nmi)))
				Toggle("WAIT", isOn: .constant(z80.control.contains(.wait)))
			}
			Rectangle()
				.stroke()
				.overlay {
					Text("Z80 CPU")
				}
			VStack(alignment: .leading) {
				Toggle("A0", isOn: .constant(z80.address.bits[0]))
				Toggle("A1", isOn: .constant(z80.address.bits[1]))
				Toggle("A2", isOn: .constant(z80.address.bits[2]))
				Toggle("A3", isOn: .constant(z80.address.bits[3]))
				Toggle("A4", isOn: .constant(z80.address.bits[4]))
				Toggle("A5", isOn: .constant(z80.address.bits[5]))
				Toggle("A6", isOn: .constant(z80.address.bits[6]))
				Toggle("A7", isOn: .constant(z80.address.bits[7]))
				Toggle("A8", isOn: .constant(z80.address.bits[8]))
				Toggle("A9", isOn: .constant(z80.address.bits[9]))
				Toggle("A10", isOn: .constant(z80.address.bits[10]))
				Toggle("A11", isOn: .constant(z80.address.bits[11]))
				Toggle("A12", isOn: .constant(z80.address.bits[12]))
				Toggle("A13", isOn: .constant(z80.address.bits[13]))
				Toggle("A14", isOn: .constant(z80.address.bits[14]))
				Toggle("A15", isOn: .constant(z80.address.bits[15]))
			}
		}
	}
}

@available(macOS 14, *)
#Preview {
	let z80 = ObservableZ80()
	return PinsView()
		.environment(z80)
}
#endif
