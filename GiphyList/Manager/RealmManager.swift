//
//  RealmManager.swift
//  GiphyList
//
//  Created by 29cm on 2020/03/06.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()

    func favoriteList() -> [The480_WStill] {
        var items: [The480_WStill] = Array()
        do {
            let realm = try Realm()
            let objects = realm.objects(The480_WStill.self)
            for object in objects {
                items.append(object)
            }
            return items
        } catch {}

        return []
    }

    func saveFavoriteItem(_ data: The480_WStill) {
        guard let realm = try? Realm() else { return }

        try? realm.write {
            realm.create(The480_WStill.self,
                         value: ["id": incrementID(), "url": data.url, "width": data.width, "height": data.height, "randomRed": data.randomRed, "randomGreen": data.randomGreen, "randomBlue": data.randomBlue],
                         update: .all)
        }
    }

    func removeFavoriteItem(_ url: String) -> Bool {
        var removed = false
        guard let realm = try? Realm() else { return false }
        let objects = realm.objects(The480_WStill.self).filter("url == '\(url)'")
        if objects.count > 0 {
            try? realm.write {
                realm.delete(objects)
                removed = true
            }
        }

        return removed
    }

    private func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(The480_WStill.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
