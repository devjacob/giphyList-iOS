//
//  DetailViewModel.swift
//  GiphyList
//
//  Created by 29cm on 2020/03/04.
//

import Foundation
import RealmSwift
import RxSwift

class DetailViewModel {
    var coordinator: SearchCoordinator!

    var scrollIndexBehaviorSubject: BehaviorSubject<Int> = BehaviorSubject(value: 0)

    var resultItems: [The480_WStill]?

    var startIndex: Int = 0 {
        didSet {
            scrollIndexBehaviorSubject.onNext(startIndex)
        }
    }

    func favoriteItem(isSave: Bool, index: Int) {
        guard let item = resultItems?[index] else { return }
        if isSave {
            RealmManager.shared.saveFavoriteItem(item)
        } else {
            print(RealmManager.shared.removeFavoriteItem(item.url))
        }
    }
}
