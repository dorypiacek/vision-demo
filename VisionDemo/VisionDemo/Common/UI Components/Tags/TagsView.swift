//
//  TagsView.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import UIKit

final class TagsView: UIView {
	
	// MARK: - Private properties
	
	private let stackView = UIStackView()
	private var tagButtons = [TagButton]()
	
	// MARK: - Initializers
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Public methods
	
	func update(with tags: [TagButton.Content]) {
		updateTagButtons(with: tags)
	}
	
	// MARK: - Private methods
	
	private func setupUI() {
		backgroundColor = .clear
		
		addSubview(stackView)
		setupStackView()
	}
	
	private func setupStackView() {
		stackView.axis = .vertical
		stackView.distribution = .equalSpacing
		stackView.spacing = Metrics.spacing.medium
		stackView.alignment = .leading
		
		stackView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	private func updateTagButtons(with tags: [TagButton.Content]) {
		tags.forEach { content in
			if let existingButton = tagButtons.first(where: { $0.titleLabel?.text == content.title }) {
				existingButton.update(with: content)
			} else {
				let button = TagButton()
				button.update(with: content)
				tagButtons.append(button)
				stackView.addArrangedSubview(button)
			}
		}
	}
}
