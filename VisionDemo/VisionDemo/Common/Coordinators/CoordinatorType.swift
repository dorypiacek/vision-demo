//
//  CoordinatorType.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import UIKit

protocol CoordinatorType {
	var children: [CoordinatorType] { get set }
	var presenter: UINavigationController { get set }

	func start()
	func showAlert(with config: AlertConfig)
}

extension CoordinatorType {
	func showAlert(with config: AlertConfig) {
		let alertController = config.controller
		presenter.present(alertController, animated: true)
	}
}
