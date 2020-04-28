//
//  StorageService.swift
//  MovieHolic
//
//  Created by apple on 4/26/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation
import RealmSwift

class StorageService {

    private let realm = try? Realm()

    func saveObject<T: Object>(object: T?) {
        try? realm?.write {
            guard let object = object else {
                return
            }
            realm?.add(object)
        }
    }

    func isListed<T: Object>(object: T.Type, id: Int?) -> Bool {
        guard let id = id else {
            return false
        }
        guard let filtered = realm?.objects(object.self).filter("id == \(id)") else {
            return false
        }
        if filtered.isEmpty {
            return false
        } else {
            return true
        }
    }

    func removeObjectWithId<T: Object>(object: T.Type, id: Int?) {
        guard let id = id else {
            return
        }
        guard let foundObject = realm?.objects(object.self).filter("id == \(id)").first else {
            return
        }
        try? realm?.write {
            realm?.delete(foundObject)
        }
    }
}
