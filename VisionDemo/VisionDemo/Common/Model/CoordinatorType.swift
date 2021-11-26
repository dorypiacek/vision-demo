//
//  CoordinatorType.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import UIKit
import Combine

protocol CoordinatorType {
	var presenter: UINavigationController { get set }
	
	func start()
	func showAlert(with config: AlertConfig)
}

extension CoordinatorType {
	func showAlert(with config: AlertConfig) {
		let alertController = config.controller
		
		if let presentedController = presenter.viewControllers.last?.presentedViewController {
			presentedController.present(alertController, animated: true)
			return
		}
		
		presenter.present(alertController, animated: true)
	}
}
