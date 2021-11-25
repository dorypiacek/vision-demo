//
//  PhotoViewController.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import UIKit
import Combine

final class PhotoViewController: UIViewController {
	
	// MARK: - Private properties
	
	private var viewModel: PhotoViewModel
	
	private var observers: [AnyCancellable] = []
	
	private let imageView = UIImageView()
	private let tagsLabel = UILabel()
	
	// MARK: - Initializers
	
	init(viewModel: PhotoViewModel) {
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		setupNavBar()
	}
	
	// MARK: - Private methods
	
	private func setupObservers() {
		viewModel.$tags
			.receive(on: DispatchQueue.main)
			.sink { [weak self] tags in
				self?.tagsLabel.text = tags.joined(separator: " ")
			}
			.store(in: &observers)
	}
	
	private func setupUI() {
		view.backgroundColor = .systemTeal
		
		view.addSubview(imageView)
		view.addSubview(tagsLabel)
		
		setupImageView()
		setupTagsLabel()
	}
	
	private func setupNavBar() {
		let closeButton = UIBarButtonItem(
			title: LocalizationKit.general.close,
			style: .plain,
			target: self,
			action: #selector(closeTapped)
		)
		
		navigationItem.rightBarButtonItem = closeButton
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	private func setupImageView() {
		imageView.image = UIImage(data: viewModel.imageData)
		imageView.contentMode = .scaleAspectFit
		
		imageView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
			make.width.height.equalTo(view.snp.width).multipliedBy(0.6)
		}
	}
	
	private func setupTagsLabel() {
		tagsLabel.textAlignment = .center
		tagsLabel.textColor = .white
		
		tagsLabel.snp.makeConstraints { make in
			make.top.equalTo(imageView.snp.bottom).offset(30)
			make.centerX.equalToSuperview()
		}
	}
	
	// MARK: - Actions
	
	@objc private func closeTapped() {
		viewModel.close()
	}
}
