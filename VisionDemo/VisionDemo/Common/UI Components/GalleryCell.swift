//
//  GalleryCell.swift
//  VisionDemo
//
//  Created by Dory on 25/11/2021.
//

import UIKit

final class GalleryCell: UICollectionViewCell {
	private let imageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(with image: UIImage) {
		imageView.image = image
	}
	
	private func setupUI() {
		addSubview(imageView)
		
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = Metrics.cornerRadius
		
		imageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}
