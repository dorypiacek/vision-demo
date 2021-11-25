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
	@Persisted var image: Data
	
	convenience init(image: Data) {
		self.init()
		
		self.image = image
		self.createdAt = Date()
	}
}
