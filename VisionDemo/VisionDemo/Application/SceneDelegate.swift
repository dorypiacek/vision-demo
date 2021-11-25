//
//  SceneDelegate.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	var mainCoordinator: CoordinatorType?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		if let windowScene = scene as? UIWindowScene {
			let navigationController = UINavigationController()
			mainCoordinator = MainCoordinator(presenter: navigationController)
			mainCoordinator?.start()
			
			window = UIWindow(windowScene: windowScene)
			window?.rootViewController = navigationController
			window?.backgroundColor = .black
			window?.overrideUserInterfaceStyle = .light
			window?.makeKeyAndVisible()
		}
	}
}

