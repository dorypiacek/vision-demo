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
	
	private var galleryCoordinator: GalleryCoordinator?
	private var photoCoordinator: PhotoCoordinator?
	
	private var photoManager = PhotoManager()
	
	private var observers: [AnyCancellable] = []
	private var photoManagerObserver: AnyCancellable?
	
	init(presenter: UINavigationController) {
		self.presenter = presenter
	}
	
	func start() {
		let viewModel = MainViewModel()
		let viewController = MainViewController(viewModel: viewModel)
		
		viewModel.addPhotoSubject
			.sink { [weak self] sourceType in
				self?.showAddPhoto(with: sourceType)
			}
			.store(in: &observers)
		
		viewModel.showAlertSubject
			.sink { [weak self] config in
				self?.showAlert(with: config)
			}
			.store(in: &observers)
		
		viewModel.openGallerySubject
			.sink { [weak self] in
				self?.showGallery()
			}
			.store(in: &observers)
		
		presenter.pushViewController(viewController, animated: true)
	}
	
	private func showAddPhoto(with sourceType: PhotoManager.SourceType) {
		photoManagerObserver = photoManager.imageSubject
			.receive(on: DispatchQueue.main)
			.sink { [weak self] image in
				self?.presenter.dismiss(animated: true) {
					self?.showPhotoDetail(with: image)
				}
			}
		
		let viewController = photoManager.makeViewController(with: sourceType)
		presenter.present(viewController, animated: true)
	}
	
	private func showPhotoDetail(with image: ProcessedImage) {
		if photoCoordinator != nil {
			photoCoordinator = nil
		}
		
		photoCoordinator = PhotoCoordinator(
			image: image,
			purpose: .addPhoto,
			presenter: presenter
		)
		
		photoCoordinator?.showGallerySubject
			.sink { [weak self] in
				self?.showGallery()
			}
			.store(in: &observers)
		
		photoCoordinator?.start()
	}
	
	private func showGallery() {
		galleryCoordinator = GalleryCoordinator(presenter: presenter)
		galleryCoordinator?.start()
	}
}
