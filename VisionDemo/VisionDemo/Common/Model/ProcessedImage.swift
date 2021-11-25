//
//  ProcessedImage.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import RealmSwift
import Foundation

class ProcessedImage: Object {
	@Persisted var id: ObjectId
	@Persisted var createdAt: Date
	@Persisted var imageData: Data
	@Persisted var tags: List<String>
	
	convenience init(imageData: Data) {
		self.init()
		
		self.imageData = imageData
		self.createdAt = Date()
	}
}
