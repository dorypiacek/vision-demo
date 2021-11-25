//
//  String+Localized.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import Foundation

public extension String {
	var localized: String {
		get {
			NSLocalizedString(self, comment: "")
		}
	}
}
