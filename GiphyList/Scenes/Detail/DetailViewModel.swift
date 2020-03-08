//
//  DetailViewModel.swift
//  GiphyList
//
//  Created by 29cm on 2020/03/04.
//

import Foundation
import RealmSwift
import RxSwift

typealias ItemTypeClosure = ((SearchType) -> Void)

class DetailViewModel {
    var coordinator: NavigationCoordinator!

    var scrollIndexBehaviorSubject: BehaviorSubject<Int> = BehaviorSubject(value: 0)

    var resultItems: [ImageItemModel]?

    var currentItemChangeAction: ItemTypeClosure?

    var currentItemType: SearchType = .gifs {
        didSet {
            currentItemChangeAction?(currentItemType)
        }
    }

    var startIndex: Int = 0 {
        didSet {
            scrollIndexBehaviorSubject.onNext(startIndex)
            if (resultItems?.count ?? 0) > startIndex {
                guard let item = resultItems?[startIndex] else { return }
                currentItemType = (item.isSticker == 1 ? .stickers : .gifs)
            }
        }
    }

    func favoriteItem(isSave: Bool, index: Int) {
        guard let item = resultItems?[index] else { return }
        if isSave {
            RealmManager.shared.saveFavoriteItem(item)
        } else {
            guard let itemID = item.itemID else { return }
            print(RealmManager.shared.removeFavoriteItem(itemID))
        }
    }
}
