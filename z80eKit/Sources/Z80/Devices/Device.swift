//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-04-11.
//

public protocol Device: AnyObject {
	var port: UInt8 { get set }
}

public struct AnyDevice {
	@usableFromInline let _read: () -> UInt8
	@usableFromInline let _write: (UInt8) -> Void

	@inlinable
	public var port: UInt8 {
		get { _read() }
		set { _write(newValue) }
	}

	@inlinable
	public init(
		read: @escaping () -> UInt8,
		write: @escaping (UInt8) -> Void
	) {
		_read = read
		_write = write
	}

	@inlinable
	public init(_ device: some Device) {
		self.init { device.port } write: { device.port = $0 }
	}
}

extension AnyDevice {

	/// Null device, always returns 0 and ignores writes.
	public static let null = AnyDevice { 0 } write: { _ in }

}
