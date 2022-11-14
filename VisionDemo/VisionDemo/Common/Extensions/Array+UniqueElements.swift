//
//  Array+UniqueElements.swift
//  VisionDemo
//
//  Created by Dory on 26/11/2021.
//

extension Array where Element: Equatable {
  func uniqueElements() -> [Element] {
	var unique = [Element]()

	for element in self {
	  if !unique.contains(element) {
		  unique.append(element)
	  }
	}

	return unique
  }
}
