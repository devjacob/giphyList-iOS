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

    func favoriteList() -> [ImageItemModel] {
        var items: [ImageItemModel] = Array()
        do {
            let realm = try Realm()
            let objects = realm.objects(ImageItemModel.self)
            for object in objects {
                items.append(object)
            }
            return items
        } catch {}

        return []
    }

    func saveFavoriteItem(_ data: ImageItemModel) {
        guard let realm = try? Realm() else { return }

        try? realm.write {
            realm.create(ImageItemModel.self,
                         value: ["id": incrementID(), "url": data.url, "width": data.width, "height": data.height, "randomRed": data.randomRed, "randomGreen": data.randomGreen, "randomBlue": data.randomBlue, "itemID": data.itemID ?? "", "isSticker": data.isSticker],
                         update: .all)
        }
    }

    func isFavoriteItem(_ itemID: String) -> Bool {
        guard let realm = try? Realm() else { return false }
        let objects = realm.objects(ImageItemModel.self).filter("itemID == '\(itemID)'")
        return objects.count > 0
    }

    func removeFavoriteItem(_ itemID: String) -> Bool {
        var removed = false
        guard let realm = try? Realm() else { return false }
        let objects = realm.objects(ImageItemModel.self).filter("itemID == '\(itemID)'")
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
        return (realm.objects(ImageItemModel.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
