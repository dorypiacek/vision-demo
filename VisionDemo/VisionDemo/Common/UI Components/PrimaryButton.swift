//
//  PrimaryButton.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import UIKit

final class PrimaryButton: UIButton {
	
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
	
	func update(with content: Content) {
		setTitle(content.title, for: .normal)
		replaceAction(for: .touchUpInside, content.action)
		alpha = content.isEnabled ? 1 : 0.5
		isEnabled = content.isEnabled
	}
	
	// MARK: - Private methods
	
	func setupUI() {
		backgroundColor = .white
		setTitleColor(.systemTeal, for: .normal)
		setTitleColor(.lightGray, for: .disabled)
		
		titleLabel?.font = UIFont.boldSystemFont(ofSize: Metrics.spacing.medium)
		
		contentEdgeInsets = UIEdgeInsets(top: Metrics.spacing.small, left: Metrics.spacing.medium, bottom: Metrics.spacing.small, right: Metrics.spacing.medium)
	}
}

// MARK: - Content
extension PrimaryButton {
	struct Content {
		var title: String
		var isEnabled: Bool
		let action: () -> Void
	}
}
