//
//  GaleryCoordinator.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import UIKit
import Combine

final class GalleryCoordinator: CoordinatorType {
	var presenter: UINavigationController
	
	private var observers: [AnyCancellable] = []
	private var photoCoordinator: PhotoCoordinator?
	
	init(presenter: UINavigationController) {
		self.presenter = presenter
	}
	
	func start() {
		let viewModel = GalleryViewModel()
		viewModel.openImageSubject
			.receive(on: DispatchQueue.main)
			.sink { [weak self] image in
				self?.showImageDetail(with: image)
			}
			.store(in: &observers)
		
		let viewController = GalleryViewController(viewModel: viewModel)
		presenter.pushViewController(viewController, animated: true)
	}
	
	private func showImageDetail(with image: ProcessedImage) {
		photoCoordinator = PhotoCoordinator(
			image: image,
			purpose: .photoDetail,
			presenter: presenter
		)
		photoCoordinator?.start()
	}
}
