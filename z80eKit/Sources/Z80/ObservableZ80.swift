//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-03-18.
//

import Observation

@available(macOS 14.0, *)
@Observable
public final class ObservableZ80: Z80 {
	public var r1: UInt64 = 0
	public var r2: UInt64 = 0
	public var ix: UInt16 = 0
	public var iy: UInt16 = 0
	public var ir: UInt16 = 0
	public var pc: UInt16 = 0
	public var sp: UInt16 = 0
	public var control: ControlPins = []
	public var instruction: UInt8 = 0
	public var data: UInt8 = 0
	public var address: UInt16 = 0
	public var tcycles: UInt32 = 0
	public var mcycles: UInt32 = 0

	public init() { }
}
