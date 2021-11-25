//
//  MainViewController.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
	private var viewModel: MainViewModel
	
	private let addButton = UIButton()
	
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	// MARK: - Private methods
	
	private func setupUI() {
		view.backgroundColor = .systemTeal
		view.addSubview(addButton)
		
		setupButton()
	}
	
	private func setupButton() {
		addButton.titleLabel?.textColor = .white
		addButton.setTitle(viewModel.buttonTitle, for: .normal)
		addButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
		
		addButton.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}
	
	@objc private func buttonTapped() {
		viewModel.addPhoto()
	}
}
