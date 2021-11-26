//
//  RealmDataProvider.swift
//  VisionDemo
//
//  Created by Dory on 24/11/2021.
//

import RealmSwift

class RealmDataProvider {
	static var shared = RealmDataProvider()
	
	private static var config: Realm.Configuration {
		var config = Realm.Configuration()
		config.deleteRealmIfMigrationNeeded = true
		return config
	}
	
	private var realm: Realm
	
	private init?() {
		do {
			self.realm = try Realm(configuration: RealmDataProvider.config, queue: .main)
		} catch let error as NSError {
			print("Realm: initialization failed: \(error.localizedDescription)")
			return nil
		}
	}
	
	func write(object: Object) {
		do {
			try realm.write {
				realm.add(object)
			}
		} catch let error as NSError {
			print("Realm: write object failed: \(error.localizedDescription)")
		}
	}
	
	func read<T: Object>(type: T.Type, with filter: String? = nil) -> Results<T>? {
		var objects = realm.objects(type)
		
		if let filter = filter {
			objects = objects.filter(filter)
		}
		return objects
	}
	
	func update(with closure: @escaping () -> Void) {
		do {
			try realm.write {
				closure()
			}
		} catch let error as NSError {
			print("Realm: update failed: \(error.localizedDescription)")
		}
	}
	
	func delete(object: Object) {
		do {
			try realm.write {
				realm.delete(object)
			}
		} catch let error as NSError {
			print("Realm: delete failed: \(error.localizedDescription)")
		}
	}
}
