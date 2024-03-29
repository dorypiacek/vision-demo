//
//  AlertConfig.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import UIKit

struct AlertConfig {
	let title: String?
	let message: String?
	let style: AlertStyle
	let actions: [AlertAction]
	
	
	init(title: String?, message: String?, style: AlertStyle, actions: [AlertAction]) {
		self.title = title
		self.message = message
		self.style = style
		self.actions = actions
	}
	
	var controller: UIAlertController {
		get {
			let controller = UIAlertController(
				title: title,
				message: message,
				preferredStyle: UIAlertController.Style(rawValue: style.rawValue) ?? .actionSheet
			)
			
			actions.forEach { action in
				controller.addAction(
					UIAlertAction(
						title: action.title,
						style: UIAlertAction.Style(rawValue: action.style.rawValue) ?? .default,
						handler: { _ in
							action.handler?()
						}
					)
				)
			}
			
			return controller
		}
	}
}

enum AlertStyle: Int {
	case actionSheet = 0
	case alert = 1
}

struct AlertAction {
	let title: String?
	let style: AlertActionStyle
	let handler: (() -> Void)?
}

enum AlertActionStyle: Int {
	case `default` = 0
	case cancel = 1
	case destructive = 2
}
