//
//  FavriteViewModel.swift
//  GiphyList
//
//  Created by 정창현 on 2020/03/01.
//

import Foundation
import RxSwift

class FavoriteViewModel {
    var coordinator: NavigationCoordinator?

    var favoriteItemsBehaviorSubject: BehaviorSubject<[ImageItemModel]?> = BehaviorSubject(value: nil)

    var favoriteItems: [ImageItemModel]? {
        didSet {
            favoriteItemsBehaviorSubject.onNext(favoriteItems)
        }
    }

    func fetchFavoriteList() {
        favoriteItems = RealmManager.shared.favoriteList()
    }

    func showDetailViewController(_ viewController: UIViewController, index: Int) {
        guard index < (favoriteItems?.count ?? 0) else { return }
        coordinator?.showDetailViewController(items: favoriteItems ?? Array(), startIndex: index)
    }
}
