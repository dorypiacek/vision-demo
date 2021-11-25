//
//  MainCoordinator.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import UIKit

final class MainCoordinator: CoordinatorType {
	var presenter: UINavigationController
	var children: [CoordinatorType] = [CoordinatorType]()
	
	init(presenter: UINavigationController) {
		self.presenter = presenter
	}
	
	func start() {
		let viewModel = MainViewModel()
		
		viewModel.onShowAlert = { [weak self] config in
			self?.showInputDialogue(with: config)
		}
		viewModel.onAddPhoto = { [weak self] sourceType in
			self?.showAddPhoto(with: sourceType)
		}
		
		let viewController = MainViewController(viewModel: viewModel)
		presenter.pushViewController(viewController, animated: true)
	}
	
	private func showInputDialogue(with config: AlertConfig) {
		showAlert(with: config)
	}
	
	private func showAddPhoto(with sourceType: PhotoManager.SourceType) {
		let photoManager = PhotoManager(sourceType: sourceType)
		let viewController = photoManager.makeViewController()
		presenter.pushViewController(viewController, animated: true)
	}
}
