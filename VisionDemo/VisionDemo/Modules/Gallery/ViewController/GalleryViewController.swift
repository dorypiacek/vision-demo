//
//  GalleryViewController.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import UIKit
import Combine

final class GalleryViewController: UIViewController {
	
	// MARK: - Private properties
	
	private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	private let filterView = TagFilterView()
	private let placeholderLabel = UILabel()
	
	private var viewModel: GalleryViewModel
	
	private var observers: [AnyCancellable] = []
	private var collectionData: [ProcessedImage] = [] {
		didSet {
			placeholderLabel.isHidden = !collectionData.isEmpty
			collectionView.reloadData()
		}
	}
	
	// MARK: - Initializers
	
	init(viewModel: GalleryViewModel) {
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
		setupObservers()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		observers.forEach { $0.cancel() }
	}
	
	// MARK: - Private methods
	
	private func setupObservers() {
		viewModel.$images
			.receive(on: DispatchQueue.main)
			.assign(to: \.collectionData, on: self)
			.store(in: &observers)
		
		viewModel.$filterContent
			.receive(on: DispatchQueue.main)
			.sink { [weak self] content in
				self?.filterView.update(with: content)
			}
			.store(in: &observers)
	}
	
	private func setupUI() {
		navigationController?.setNavigationBarHidden(false, animated: true)
		
		view.backgroundColor = .systemTeal
		
		view.addSubview(collectionView)
		view.addSubview(filterView)
		view.addSubview(placeholderLabel)
		
		setupFilterView()
		setupCollectionView()
		setupPlaceholderLabel()
	}
	
	private func setupCollectionView() {
		collectionView.backgroundColor = .clear
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: "GalleryCell")
		
		collectionView.snp.makeConstraints { make in
			make.top.equalTo(filterView.snp.bottom)
			make.leading.trailing.bottom.equalToSuperview()
		}
	}
	
	private func setupFilterView() {
		filterView.snp.makeConstraints { make in
			make.height.equalTo(Metrics.spacing.large)
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			make.leading.trailing.equalToSuperview().inset(Metrics.spacing.small)
		}
	}
	
	private func setupPlaceholderLabel() {
		placeholderLabel.text = LocalizationKit.gallery.noPhotosPlaceholder
		placeholderLabel.font = UIFont.boldSystemFont(ofSize: 20)
		placeholderLabel.textAlignment = .center
		placeholderLabel.textColor = .white
		placeholderLabel.numberOfLines = 0
		
		placeholderLabel.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.width.lessThanOrEqualToSuperview().inset(Metrics.spacing.medium)
		}
		
		placeholderLabel.isHidden = !collectionData.isEmpty
	}
}

// MARK: - UICollectionViewDelegate

extension GalleryViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		viewModel.openImage(at: indexPath.row)
	}
}

// MARK: - UICollectionViewDataSource

extension GalleryViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		collectionData.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? GalleryCell ?? GalleryCell()
		
		if let image = collectionData[indexPath.row].image {
			cell.update(with: image)
		}
		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
			let size = collectionView.bounds.width / 3
			return CGSize(width: size, height: size)
		}
		
		let totalSpace = flowLayout.sectionInset.left
			+ flowLayout.sectionInset.right
		+ 2 * flowLayout.minimumInteritemSpacing
		
		let size = Int(collectionView.bounds.width - totalSpace) / 3
		return CGSize(width: size, height: size)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		UIEdgeInsets(top: Metrics.spacing.small, left: Metrics.spacing.verySmall, bottom: 0, right: Metrics.spacing.verySmall)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return Metrics.spacing.verySmall
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return Metrics.spacing.verySmall
	}
}
