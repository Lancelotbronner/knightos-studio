//
//  DispatchSource+Combine.swift
//
//
//  Created by Christophe Bronner on 2024-06-25.
//

import System
import Combine
import Foundation

extension DispatchSource {

	/// A publisher that emits events in the file system.
	public struct FileSystemMonitor: Publisher {
		public typealias Output = FileSystemEvent
		public typealias Failure = Never

		public let file: FileHandle
		public let mask: FileSystemEvent
		public let queue: DispatchQueue?

		public init(_ handle: FileHandle, for eventMask: FileSystemEvent, on queue: DispatchQueue? = nil) {
			file = handle
			mask = eventMask
			self.queue = queue
		}

		public func receive(subscriber: some Subscriber<Output, Failure>) {
			subscriber.receive(subscription: Subscription(subscriber, from: self))
		}

		/// The subscription to receive file system events
		private final class Subscription<Downstream: Subscriber<Output, Failure>>: Combine.Subscription {

			private var downstream: Downstream?
			private let lock = os_unfair_lock_t.allocate(capacity: 1)
			private let file: FileHandle
			private let mask: FileSystemEvent
			private var queue: DispatchQueue?
			private var monitor: (any DispatchSourceFileSystemObject)?
			var pending = Subscribers.Demand.none

			init(_ downstream: Downstream, from publisher: FileSystemMonitor) {
				self.downstream = downstream
				self.file = publisher.file
				self.mask = publisher.mask
				self.queue = publisher.queue
				lock.initialize(to: os_unfair_lock_s())
			}

			deinit {
				lock.deallocate()
			}

			private func receive(_ event: Output) {
				guard let downstream else { return }

				os_unfair_lock_lock(lock)
				let fire = pending > .none
				if fire {
					pending -= 1
					if pending == .none {
						monitor?.suspend()
					}
				}
				os_unfair_lock_unlock(lock)

				guard fire else { return }
				let additional = downstream.receive(event)
				os_unfair_lock_lock(lock)
				pending += additional
				os_unfair_lock_unlock(lock)
			}

			func request(_ demand: Subscribers.Demand) {
				os_unfair_lock_lock(lock)

				let monitor: any DispatchSourceFileSystemObject
				let needsResume: Bool

				if let current = self.monitor {
					monitor = current
					needsResume = pending == .none
				} else {
					monitor = DispatchSource.makeFileSystemObjectSource(fileDescriptor: file.fileDescriptor, eventMask: mask, queue: queue)
					monitor.setEventHandler { [weak self] in
						guard let self, let monitor = self.monitor else { return }
						self.receive(monitor.data)
					}
					self.monitor = monitor
					needsResume = true
				}

				pending += demand
				os_unfair_lock_unlock(lock)

				guard !needsResume else { return }
				monitor.resume()
			}

			func cancel() {
				os_unfair_lock_lock(lock)

				let monitor = monitor
				self.monitor = nil
				self.queue = nil

				os_unfair_lock_unlock(lock)

				monitor?.cancel()
				try? file.close()
			}
		}

	}
}

extension Publishers {

	public typealias DispatchFileSystemMonitorPublisher = Publishers.MakeConnectable<Publishers.Share<DispatchSource.FileSystemMonitor>>

	/// Creates a new publisher for monitoring file system events.
	///
	/// - Parameters:
	///   - fileDescriptor: A file descriptor pointing to an open file or socket.
	///   - eventMask: The set of events you want to monitor. For a list of possible values,
	///   see [DispatchSource.FileSystemEvent](https://developer.apple.com/documentation/dispatch/dispatchsource/filesystemevent).
	///
	/// - Returns: A publisher that emits events occurring at the observed file.
	///
	public static func monitor(_ handle: FileHandle, for eventMask: DispatchSource.FileSystemEvent, on queue: DispatchQueue? = nil) -> DispatchFileSystemMonitorPublisher {
		DispatchSource.FileSystemMonitor(handle, for: eventMask, on: queue).share().makeConnectable()
	}

}
