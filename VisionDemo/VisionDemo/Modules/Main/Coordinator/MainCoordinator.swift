//
//  MainCoordinator.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import UIKit
import SwiftUI
import Combine

final class MainCoordinator: CoordinatorType {
	var presenter: UINavigationController
	var children: [CoordinatorType] = [CoordinatorType]()
	
	private var photoManager = PhotoManager()
	private var observers: [AnyCancellable] = []
	
	private var photoCoordinator: CoordinatorType?
	
	init(presenter: UINavigationController) {
		self.presenter = presenter
	}
	
	func start() {
		let viewModel = MainViewModel()
		viewModel.addPhotoSubject
			.sink { [weak self] sourceType in
				self?.showAddPhoto(with: sourceType)
			}
			.store(in: &observers)
		
		viewModel.showAlertSubject
			.sink { [weak self] config in
				self?.showInputDialogue(with: config)
			}
			.store(in: &observers)
		
		let viewController = MainViewController(viewModel: viewModel)
		presenter.pushViewController(viewController, animated: true)
	}
	
	private func showInputDialogue(with config: AlertConfig) {
		showAlert(with: config)
	}
	
	private func showAddPhoto(with sourceType: PhotoManager.SourceType) {
		photoManager.$image
			.receive(on: DispatchQueue.main)
			.sink { [weak self] image in
				if let image = image {
					self?.presenter.dismiss(animated: true, completion: nil)
					self?.showPhotoDetail(with: image)
				}
			}
			.store(in: &observers)
		
		let viewController = photoManager.makeViewController(with: sourceType)
		presenter.present(viewController, animated: true)
	}
	
	private func showPhotoDetail(with image: ProcessedImage) {
		photoCoordinator = PhotoCoordinator(image: image, presenter: presenter)
		photoCoordinator?.start()
	}
}
