//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-03-18.
//

import EmulationKit

public struct StatusFlags: OptionSet {
	public var rawValue: UInt8

	@inlinable
	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}

	public static let c = Self(rawValue: 0x1)
	public static let n = Self(rawValue: 0x2)
	public static let pv = Self(rawValue: 0x4)
	public static let h = Self(rawValue: 0x10)
	public static let z = Self(rawValue: 0x40)
	public static let s = Self(rawValue: 0x80)

	/// Carry flag
	@inlinable
	public var c: Bool {
		get { rawValue.bits[0] }
		set { rawValue.bits[0] = newValue }
	}

	/// Add/Subtract flag
	@inlinable
	public var n: Bool {
		get { rawValue.bits[1] }
		set { rawValue.bits[1] = newValue }
	}

	/// Parity/Overflow
	@inlinable
	public var pv: Bool {
		get { rawValue.bits[2] }
		set { rawValue.bits[2] = newValue }
	}

	/// Half-Carry
	@inlinable
	public var h: Bool {
		get { rawValue.bits[4] }
		set { rawValue.bits[4] = newValue }
	}

	/// Zero
	@inlinable
	public var z: Bool {
		get { rawValue.bits[6] }
		set { rawValue.bits[6] = newValue }
	}

	/// Sign
	@inlinable
	public var s: Bool {
		get { rawValue.bits[7] }
		set { rawValue.bits[7] = newValue }
	}
}
