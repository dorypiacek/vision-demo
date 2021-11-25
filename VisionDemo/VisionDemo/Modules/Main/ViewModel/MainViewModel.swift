//
//  MainViewModel.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import Combine

final class MainViewModel {
	let buttonTitle: String = LocalizationKit.main.buttonTitle
	
	var showAlertSubject = PassthroughSubject<AlertConfig, Never>()
	var addPhotoSubject = PassthroughSubject<PhotoManager.SourceType, Never>()
	
	func addPhoto() {
		showAlertSubject.send(makeInputDialogue())
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
