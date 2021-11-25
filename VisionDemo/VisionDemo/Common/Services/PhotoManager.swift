//
//  PhotoManager.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import UIKit
import PhotosUI

final class PhotoManager: NSObject, ObservableObject {
	public enum SourceType {
		case camera
		case photoLibrary
	}
	
	// MARK: - Public properties
	
	@Published var image: UIImage?
	
	// MARK: - Private properties
	
	private var sourceType: SourceType
	
	// MARK: - Initializer
	
	init(sourceType: SourceType) {
		self.sourceType = sourceType
	}
	
	// MARK: - Public methods
	
	public func makeViewController() -> UIViewController {
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
}

// MARK: - PHPickerViewControllerDelegate

extension PhotoManager: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		guard let result = results.first else { return }
		let provider = result.itemProvider
		
		provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
			if let pickedImage = image as? UIImage {
				self?.image = pickedImage
			}
		}
	}
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension PhotoManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let pickedImage = info[.originalImage] as? UIImage else {
			return
		}
		
		image = pickedImage
	}
}

