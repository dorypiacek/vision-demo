//
//  LocalizationKit.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

struct LocalizationKit {
	static let general = General()
	static let main = Main()
	static let photo = Photo()
}

struct General {
	let cancel = "general_cancel".localized
	let close = "general_close".localized
	let ok = "general_ok".localized
}

struct Main {
	let buttonTitle = "main_addPhoto_buttonTitle".localized
	let dialogueTitle = "main_addPhoto_dialogueTitle".localized
	let captureAction = "main_addPhoto_captureAction".localized
	let chooseAction = "main_addPhoto_chooseAction".localized
	let missingPermissionsTitle = "main_addPhoto_missingPermissions_title".localized
	let missingPermissionsMessage = "main_addPhoto_missingPermissions_message".localized
}

struct Photo {
	let replaceButtonTitle = "photo_replacePhoto_buttonTitle".localized
	let confirmButtonTitle = "photo_confirmButton_title".localized
	let closeDialogueTitle = "photo_close_dialogueTitle".localized
	let closeDialogueMessage = "photo_close_dialogueMessage".localized
}
