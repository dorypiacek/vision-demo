//
//  UIButton+Closure.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import Foundation
import UIKit

/// Credit for this super-helpful piece of code goes to my ex-colleague and mentor Jan "Číslo" Čislinský (https://github.com/jcislinsky ).
private var closures: Set<ActionSleeve> = []
private var counter = 0

public extension UIControl {
	/// Ads given closure as a target for a given event.
	///
	/// - Warning: Adding new closure don't remove previously added closures.
	///     If you register multiple closures for the one event, all of them
	///     will be called when event is triggered.
	func addAction(for controlEvent: UIControl.Event, _ closure: @escaping () -> Void) {
		dispatchPrecondition(condition: .onQueue(.main))

		let sleeve = ActionSleeve(ObjectIdentifier(self).hashValue, controlEvent, counter, closure)
		counter += 1
		addTarget(sleeve, action: #selector(ActionSleeve.invoke), for: controlEvent)
		closures.insert(sleeve)
		onDealloc(of: self) { [weak sleeve] in
			if let sleeve = sleeve {
				closures.remove(sleeve)
			}
		}
	}
	/// Ads given closure as a target for a given event. Before closure is
	/// added as a target it removes previously added closures for a specific
	/// event.
	func replaceAction(for controlEvent: UIControl.Event, _ closure: @escaping () -> Void) {
		dispatchPrecondition(condition: .onQueue(.main))

		removeActions(for: controlEvent)
		addAction(for: controlEvent, closure)
	}
	/// Removes all previously registered closures.
	func removeAllActions() {
		dispatchPrecondition(condition: .onQueue(.main))

		closures = Set(closures.filter {
			$0.ownerId != ObjectIdentifier(self).hashValue
		})
	}
	/// Removes all previously registered closures registered for given event.
	func removeActions(for controlEvent: UIControl.Event) {
		dispatchPrecondition(condition: .onQueue(.main))

		closures = Set(closures.filter {
			!($0.ownerId == ObjectIdentifier(self).hashValue && $0.event == controlEvent)
		})
	}
}

private class ActionSleeve: Hashable {
	let ownerId: Int
	let event: UIControl.Event
	let uniq: Int
	let closure: () -> Void

	init(_ ownerId: Int, _ event: UIControl.Event, _ uniq: Int, _ closure: @escaping () -> Void) {
		self.ownerId = ownerId
		self.event = event
		self.uniq = uniq
		self.closure = closure
	}

	@objc func invoke () {
		closure()
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(ownerId.hashValue)
		hasher.combine(event.rawValue.hashValue)
		hasher.combine(uniq.hashValue)
	}
}

// swiftlint:disable:next operator_whitespace
private func ==(lhs: ActionSleeve, rhs: ActionSleeve) -> Bool {
	lhs.hashValue == rhs.hashValue
}

final class DeallocTracker {
	let onDealloc: () -> Void

	init(onDealloc: @escaping () -> Void) {
		self.onDealloc = onDealloc
	}

	deinit {
		onDealloc()
	}
}

/// Executes action upon deallocation of owner
///
/// - Parameters:
///   - owner: Owner to track.
///   - closure: Closure to execute.
public func onDealloc(of owner: Any, closure: @escaping () -> Void) {
	while true {
		// Generates random key for association and checks that it wasn't used already
		if let key = UnsafeRawPointer(bitPattern: UInt(arc4random())), objc_getAssociatedObject(owner, key) == nil {
			let tracker = DeallocTracker(onDealloc: closure)
			objc_setAssociatedObject(owner, key, tracker, .OBJC_ASSOCIATION_RETAIN)
			break
		}
	}
}
