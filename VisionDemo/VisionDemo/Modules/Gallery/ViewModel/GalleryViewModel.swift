//
//  GalleryViewModel.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import Combine
import RealmSwift
import Foundation

final class GalleryViewModel {
	@Published var images: [ProcessedImage] = []
	@Published var filterContent: [TagButton.Content] = []
	
	let openImageSubject = PassthroughSubject<ProcessedImage, Never>()
	
	private var results: Results<ProcessedImage>?
	private var notificationToken: NotificationToken?
	
	@Published private var activeFilters: [String] = []
	private var filtersObserver: AnyCancellable?
	
	private var imageCategories: [String] = []
	private var allImages: [ProcessedImage] = []
	
	init() {
		loadImages()
		
		filtersObserver = $activeFilters.sink { [weak self] filters in
			self?.filterImages(with: filters)
		}
	}
	
	func openImage(at index: Int) {
		openImageSubject.send(images[index])
	}
	
	private func loadImages() {
		let realmDataProvider = RealmDataProvider.shared
		results = realmDataProvider?.read(type: ProcessedImage.self, with: nil)
		
		notificationToken = results?.observe(on: .main, { [weak self] changes in
			switch changes {
			case .update(let items, _, _, _), .initial(let items):
				self?.updateImages(with: items)
			default: break
			}
		})
	}
	
	private func updateImages(with results: Results<ProcessedImage>) {
		images = results
			.toArray(ofType: ProcessedImage.self)
			.sorted(by: {
				$0.createdAt.timeIntervalSince1970 < $1.createdAt.timeIntervalSince1970
			})
		
		allImages = images
		
		saveImageCategories()
		makeFilterContent()
	}
	
	private func saveImageCategories() {
		var tags: [String] = []
		
		allImages.forEach { image in
			image.tags.forEach { tag in
				tags.append(tag)
			}
		}
		
		// Sort the tags by most occurencies
		let occurences = tags.reduce(into: [String: Int](), { result, element in
			result[element, default: 0] += 1
		})
		tags = tags.sorted(by: { occurences[$0] ?? 0 > occurences[$1] ?? 0 })
		
		imageCategories = tags.uniqueElements()
	}
	
	private func makeFilterContent() {
		filterContent = imageCategories.map { category in
			TagButton.Content(
				title: category.components(separatedBy: ",")[0],
				isSelected: activeFilters.contains(category),
				action: { [weak self] in
					guard let self = self else {
						return
					}
					
					if self.activeFilters.contains(category) {
						self.activeFilters.removeAll { $0 == category }
					} else {
						self.activeFilters.append(category)
					}
					
					self.makeFilterContent()
				}
			)
		}
	}
	
	private func filterImages(with filters: [String]) {
		guard !filters.isEmpty else {
			images = allImages
			return
		}
		
		images = allImages.filter { image in
			let tags = Set(image.tags)
			let filters = Set(filters)
			return filters.isSubset(of: tags)
		}
	}
}
