//
//  PhotoViewModel.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import Combine
import Foundation

final class PhotoViewModel {
	
	// MARK: - Public properties
	
	lazy var imageData: Data = image.imageData
	
	@Published var tags: [String] = []
	@Published var isLoading: Bool = false
	
	var imageSavedSubject = PassthroughSubject<Void, Never>()
	var showAlertSubject = PassthroughSubject<AlertConfig, Never>()
	var closeSubject = PassthroughSubject<Void, Never>()
	
	// MARK: - Private properties
	
	private var image: ProcessedImage
	
	// MARK: - Initializer
	
	init(image: ProcessedImage) {
		self.image = image
	}
	
	// MARK: Public methods
	
	func close() {
		closeSubject.send()
	}
}
