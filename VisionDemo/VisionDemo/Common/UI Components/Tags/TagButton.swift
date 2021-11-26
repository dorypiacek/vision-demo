//
//  TagButton.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import UIKit

final class TagButton: UIButton {
	
	// MARK: - Initializers
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Overrides
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = frame.height / 2
	}
	
	// MARK: - Public methods
	
	func update(with content: TagButton.Content) {
		setTitle(content.title, for: .normal)
		
		if let action = content.action {
			replaceAction(for: .touchUpInside, action)
			isUserInteractionEnabled = true
		} else {
			isUserInteractionEnabled = false
		}
		
		isSelected = content.isSelected
		backgroundColor = content.isSelected ? .white : .clear
	}
	
	// MARK: - Private methods
	
	private func setupUI() {
		backgroundColor = .white
		
		setTitleColor(.systemTeal, for: .selected)
		setTitleColor(.white, for: .normal)
		
		layer.borderWidth = Metrics.borderWidth
		layer.borderColor = UIColor.white.cgColor
		
		titleLabel?.font = UIFont.systemFont(ofSize: 13)
		
		contentEdgeInsets = UIEdgeInsets(top: Metrics.spacing.verySmall, left: Metrics.spacing.small, bottom: Metrics.spacing.verySmall, right: Metrics.spacing.small)
	}
}

// MARK: - Content

extension TagButton {
	struct Content {
		let title: String
		var isSelected: Bool
		let action: (() -> Void)?
	}
}
