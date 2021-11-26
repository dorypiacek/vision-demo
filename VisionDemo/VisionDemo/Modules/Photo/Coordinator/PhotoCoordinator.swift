//
//  PhotoCoordinator.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import UIKit
import Combine

final class PhotoCoordinator: CoordinatorType {
	var presenter: UINavigationController
	
	var showGallerySubject = PassthroughSubject<Void, Never>()
	
	private var image: ProcessedImage
	private var purpose: PhotoViewModel.Purpose
	
	private var observers: [AnyCancellable] = []
	
	init(image: ProcessedImage, purpose: PhotoViewModel.Purpose, presenter: UINavigationController) {
		self.image = image
		self.purpose = purpose
		self.presenter = presenter
	}
	
	func start() {
		let viewModel = PhotoViewModel(image: image, purpose: purpose)
		viewModel.closeSubject
			.receive(on: DispatchQueue.main)
			.sink { [weak self] in
				self?.presenter.dismiss(animated: true)
			}
			.store(in: &observers)
		
		viewModel.imageSavedSubject
			.receive(on: DispatchQueue.main)
			.sink { [weak self] in
				self?.presenter.dismiss(animated: true) {
					self?.showGallerySubject.send()
				}
			}
			.store(in: &observers)
		
		viewModel.showAlertSubject
			.receive(on: DispatchQueue.main)
			.sink { [weak self] config in
				self?.showAlert(with: config)
			}
			.store(in: &observers)
		
		let viewController = PhotoViewController(viewModel: viewModel)
		viewController.isModalInPresentation = purpose == .addPhoto
		
		presenter.present(viewController, animated: true)
	}
}
