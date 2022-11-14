//
//  MainViewModel.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import Combine

final class MainViewModel {
	
	// MARK: Public properties
	
	lazy var addPhotoButtonContent: PrimaryButton.Content = makeAddButtonContent()
	lazy var galeryButtonContent: PrimaryButton.Content = makeGaleryButtonContent()
	
	var showAlertSubject = PassthroughSubject<AlertConfig, Never>()
	var addPhotoSubject = PassthroughSubject<PhotoManager.SourceType, Never>()
	var openGallerySubject = PassthroughSubject<Void, Never>()
	
	// MARK: Private methods

	private func makeAddButtonContent() -> PrimaryButton.Content {
		PrimaryButton.Content(title: LocalizationKit.main.buttonTitle, isEnabled: true) { [weak self] in
			guard let self = self else { return }
			
			self.showAlertSubject.send(self.makeInputDialogue())
		}
	}
	
	private func makeGaleryButtonContent() -> PrimaryButton.Content {
		PrimaryButton.Content(title: "Open Gallery", isEnabled: true) { [weak self] in
			guard let self = self else { return }
			
			self.openGallerySubject.send()
		}
	}
	
	private func makeInputDialogue() -> AlertConfig {
		return AlertConfig(
			title: LocalizationKit.main.dialogueTitle,
			message: nil,
			style: .actionSheet,
			actions: [
				AlertAction(
					title: LocalizationKit.main.captureAction,
					style: .default,
					handler: { [weak self] in
						self?.addPhotoSubject.send(.camera)
					}
				),
				AlertAction(
					title: LocalizationKit.main.chooseAction,
					style: .default,
					handler: { [weak self] in
						self?.addPhotoSubject.send(.photoLibrary)
					}
				),
				AlertAction(
					title: LocalizationKit.general.cancel,
					style: .cancel,
					handler: nil
				)
			]
		)
	}
}
