//
//  MainViewModel.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

final class MainViewModel {
	let buttonTitle: String = LocalizationKit.main.buttonTitle
	
	var onShowAlert: ((AlertConfig) -> Void)?
	var onAddPhoto: ((PhotoManager.SourceType) -> Void)?
	
	func addPhoto() {
		onShowAlert?(makeInputDialogue())
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
						self?.onAddPhoto?(.camera)
					}
				),
				AlertAction(
					title: LocalizationKit.main.chooseAction,
					style: .default,
					handler: { [weak self] in
						self?.onAddPhoto?(.photoLibrary)
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
