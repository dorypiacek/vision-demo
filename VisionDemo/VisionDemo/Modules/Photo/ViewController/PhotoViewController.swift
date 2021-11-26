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
	
	private let closeButton = UIButton()
	private let imageView = UIImageView()
	private let tagsView = TagsView()
	private let saveButton = PrimaryButton()
	
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
		setupObservers()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupObservers()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		observers.forEach { $0.cancel() }
	}
	
	// MARK: - Private methods
	
	private func setupObservers() {
		viewModel.$tags
			.receive(on: DispatchQueue.main)
			.sink { [weak self] tags in
				guard let tags = tags else {
					self?.tagsView.isHidden = true
					return
				}
				
				self?.tagsView.isHidden = false
				self?.tagsView.update(with: tags)
			}
			.store(in: &observers)
		
		viewModel.$saveButtonContent
			.receive(on: DispatchQueue.main)
			.sink { [weak self] content in
				if let content = content {
					self?.saveButton.isHidden = false
					self?.saveButton.update(with: content)
				} else {
					self?.saveButton.isHidden = true
				}
			}
			.store(in: &observers)
	}
	
	private func setupUI() {
		view.backgroundColor = .systemTeal
		
		[closeButton, imageView, tagsView, saveButton].forEach(view.addSubview)
		
		setupCloseButton()
		setupImageView()
		setupTagsView()
		setupSaveButton()
	}
	
	private func setupCloseButton() {
		closeButton.setTitle(LocalizationKit.general.close, for: .normal)
		closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
		
		closeButton.snp.makeConstraints { make in
			make.top.trailing.equalToSuperview().inset(Metrics.spacing.medium)
		}
	}
	
	private func setupImageView() {
		imageView.image = UIImage(data: viewModel.imageData)
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = Metrics.cornerRadius
		
		imageView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(closeButton.snp.bottom).offset(Metrics.spacing.large)
			make.width.height.equalTo(view.snp.width).multipliedBy(0.7)
		}
	}
	
	private func setupTagsView() {
		tagsView.snp.makeConstraints { make in
			make.top.equalTo(imageView.snp.bottom).offset(Metrics.spacing.veryLarge)
			make.leading.equalToSuperview().offset(Metrics.spacing.large)
			make.trailing.lessThanOrEqualToSuperview().inset(Metrics.spacing.large)
		}
	}
	
	private func setupSaveButton() {
		saveButton.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Metrics.spacing.veryLarge)
		}
	}
	
	// MARK: - Actions
	
	@objc private func closeTapped() {
		viewModel.close()
	}
}
