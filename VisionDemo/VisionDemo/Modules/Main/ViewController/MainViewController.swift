//
//  MainViewController.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
	
	// MARK: Private properties
	
	private var viewModel: MainViewModel
	
	private let addButton = PrimaryButton()
	private let galleryButton = PrimaryButton()
	
	// MARK: Initializers
	
	init(viewModel: MainViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Overrides
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	// MARK: - Private methods
	
	private func setupUI() {
		view.backgroundColor = .systemTeal
		view.addSubview(addButton)
		view.addSubview(galleryButton)
		
		setupButtons()
	}
	
	private func setupButtons() {
		addButton.update(with: viewModel.addPhotoButtonContent)
		addButton.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
		
		galleryButton.update(with: viewModel.galeryButtonContent)
		galleryButton.snp.makeConstraints { make in
			make.top.equalTo(addButton.snp.bottom).offset(Metrics.spacing.medium)
			make.centerX.equalToSuperview()
		}
	}
}
