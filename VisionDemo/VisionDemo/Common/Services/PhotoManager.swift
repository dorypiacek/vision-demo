//
//  PhotoManager.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import UIKit
import PhotosUI
import Combine

final class PhotoManager: NSObject {
	public enum SourceType {
		case camera
		case photoLibrary
	}
	
	// MARK: - Public properties
	
	var imageSubject = PassthroughSubject<ProcessedImage, Never>()
	
	// MARK: - Public methods
	
	public func makeViewController(with sourceType: SourceType) -> UIViewController {
		sourceType == .camera ? makePhotoCaptureController() : makeChooseImageController()
	}
	
	// MARK: - Private methods
	
	private func makeChooseImageController() -> UIViewController {
		var config = PHPickerConfiguration()
		config.filter = .images
		config.selectionLimit = 1
		let picker = PHPickerViewController(configuration: config)
		picker.delegate = self
		return picker
	}
	
	private func makePhotoCaptureController() -> UIViewController {
		let imagePicker = UIImagePickerController()
		imagePicker.sourceType = .camera
		imagePicker.delegate = self
		return imagePicker
	}
	
	private func process(pickedImage: UIImage) {
		guard let imageData = pickedImage.jpegData(compressionQuality: 0.0) else {
			return
		}
		
		let image = ProcessedImage(imageData: imageData)
		imageSubject.send(image)
	}
}

// MARK: - PHPickerViewControllerDelegate

extension PhotoManager: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		guard let result = results.first else { return }
		let provider = result.itemProvider
		
		provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
			if let pickedImage = image as? UIImage {
				self?.process(pickedImage: pickedImage)
			}
		}
	}
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension PhotoManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let pickedImage = info[.originalImage] as? UIImage {
			process(pickedImage: pickedImage)
		}
	}
}

