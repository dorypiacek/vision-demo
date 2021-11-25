//
//  PhotoCoordinator.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import UIKit
import Combine

final class PhotoCoordinator: CoordinatorType {
	var children: [CoordinatorType] = []
	
	var presenter: UINavigationController
	
	private var image: ProcessedImage
	private var observers: [AnyCancellable] = []
	
	init(image: ProcessedImage, presenter: UINavigationController) {
		self.image = image
		self.presenter = presenter
	}
	
	func start() {
		let viewModel = PhotoViewModel(image: image)
		viewModel.closeSubject
			.receive(on: DispatchQueue.main)
			.sink { [weak self] in
				self?.presenter.dismiss(animated: true)
			}
			.store(in: &observers)
		viewModel.showAlertSubject
			.receive(on: DispatchQueue.main)
			.sink { [weak self] config in
				self?.showAlert(with: config)
			}
			.store(in: &observers)
		
		let viewController = PhotoViewController(viewModel: viewModel)
		presenter.present(viewController, animated: true)
	}
}
