//
//  ImageProcessing.swift
//  VisionDemo
//
//  Created by Dory on 26/11/2021.
//

import Vision
import UIKit
import Combine

final class ImageProcessor {
	struct Category {
		var name: String
		var confidence: Float
	}
	
	// MARK: - Public properties
	
	var categoriesSubject = PassthroughSubject<[Category]?, Error>()
	
	// MARK: - Private properties

	private lazy var visionModel: VNCoreMLModel = makeVisionModel()
	
	// MARK: - Public methods

	func getCategories(for photo: ProcessedImage) throws {
		guard let image = photo.image else {
			return
		}
		
		let orientation = CGImagePropertyOrientation(image.imageOrientation)

		guard let cgImage = image.cgImage else {
			fatalError("Photo doesn't have underlying CGImage.")
		}

		let imageClassificationRequest = makeRequest()

		let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation)
		let requests: [VNRequest] = [imageClassificationRequest]

		try handler.perform(requests)
	}
	
	// MARK: - Private methods

	private func makeVisionModel() -> VNCoreMLModel {
		let config = MLModelConfiguration()

		guard let model = try? SqueezeNet(configuration: config).model else {
			fatalError("App failed to create an image classifier model instance.")
		}

		guard let visionModel = try? VNCoreMLModel(for: model) else {
			fatalError("App failed to create a `VNCoreMLModel` instance.")
		}

		return visionModel
	}

	private func makeRequest() -> VNImageBasedRequest {
		let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
			var categories: [Category]?
			
			if let error = error {
				self?.categoriesSubject.send(completion: .failure(error))
				return
			}
			
			guard let observations = request.results as? [VNClassificationObservation] else {
				self?.categoriesSubject.send(nil)
				return
			}

			categories = observations
				.map { Category(name: $0.identifier, confidence: $0.confidence) }
				.filter { $0.confidence > 0.1 }
			
			self?.categoriesSubject.send(categories)
		}

		request.imageCropAndScaleOption = .scaleFit
		return request
	}
}
