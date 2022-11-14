//
//  PhotoViewModel.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import Combine
import Foundation
import RealmSwift

final class PhotoViewModel {
	enum Purpose {
		case addPhoto
		case photoDetail
	}
	
	// MARK: - Public properties
	
	lazy var imageData: Data = image.imageData
	
	@Published var tags: [TagButton.Content]?
	@Published var saveButtonContent: PrimaryButton.Content?
	
	var imageSavedSubject = PassthroughSubject<Void, Never>()
	var showAlertSubject = PassthroughSubject<AlertConfig, Never>()
	var closeSubject = PassthroughSubject<Void, Never>()
	
	// MARK: - Private properties
	
	private var image: ProcessedImage
	private var purpose: Purpose
	
	private let imageProcessor = ImageProcessor()
	
	private var categoriesObserver: AnyCancellable?
	private var selectedTags: [String]? {
		tags?
			.filter { $0.isSelected }
			.compactMap { $0.title }
	}
	
	// MARK: - Initializer
	
	init(image: ProcessedImage, purpose: Purpose) {
		self.image = image
		self.purpose = purpose
		
		setupContent()
		setupObservers()
		
		purpose == .addPhoto ? getImageTags() : makeTagsContent()
	}
	
	// MARK: Public methods
	
	func close() {
		purpose == .addPhoto
			? showAlertSubject.send(makeAreYouSureAlertConfig())
			: closeSubject.send()
	}
	
	// MARK: Private methods
	
	private func setupContent() {
		guard purpose == .addPhoto else {
			saveButtonContent = nil
			return
		}
		
		saveButtonContent = PrimaryButton.Content(
			title: LocalizationKit.photo.confirmButtonTitle,
			isEnabled: true,
			action: { [weak self] in
				self?.saveImage()
			}
		)
	}
	
	private func setupObservers() {
		guard purpose == .addPhoto else { return }
		
		categoriesObserver = imageProcessor.categoriesSubject
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { error in
					print("Image processing failed: \(error)")
				},
				receiveValue: { [weak self] categories in
					guard let categories = categories else {
						self?.tags = nil
						return
					}
				
					self?.makeTagsContent(with: categories)
				}
		)
	}
	
	private func saveImage() {
		guard let tags = tags, purpose == .addPhoto else {
			return
		}
		
		let realmDataProvider = RealmDataProvider.shared
		let selectedTags = tags
			.filter { $0.isSelected }
			.map { $0.title }
		
		realmDataProvider?.write(object: image)
		realmDataProvider?.update(with: { [weak self] in
			self?.image.tags.append(objectsIn: selectedTags)
		})
		
		imageSavedSubject.send()
	}
	
	private func getImageTags() {
		do {
			try imageProcessor.getCategories(for: image)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	private func makeTagsContent() {
		var content: [TagButton.Content] = []
	
		image.tags.forEach { tag in
			content.append(TagButton.Content(title: tag, isSelected: true, action: nil))
		}
		
		tags = content
	}
	
	private func makeTagsContent(with categories: [ImageProcessor.Category]) {
		var content: [TagButton.Content] = []
		
		for (i, category) in categories.enumerated() {
			content.append(TagButton.Content(title: category.name, isSelected: true) { [weak self] in
				self?.selectTag(at: i)
			})
		}
		
		tags = content
	}
	
	private func selectTag(at index: Int) {
		tags?[index].isSelected.toggle()
	}
	
	private func makeAreYouSureAlertConfig() -> AlertConfig {
		AlertConfig(
			title: LocalizationKit.photo.closeDialogueTitle,
			message: LocalizationKit.photo.closeDialogueMessage,
			style: .actionSheet,
			actions: [
				AlertAction(
					title: LocalizationKit.general.close,
					style: .destructive,
					handler: { [weak self] in
						self?.closeSubject.send()
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
