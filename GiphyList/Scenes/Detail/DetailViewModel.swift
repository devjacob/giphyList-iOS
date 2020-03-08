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
    var resultBehaviorSubject: BehaviorSubject<[ImageItemModel]?> = BehaviorSubject(value: nil)

    private var disposeBag: DisposeBag = DisposeBag()

    var resultItems: [ImageItemModel] = Array()

    var currentItemChangeAction: ItemTypeClosure?

    var offset: Int?
    var totalCount: Int?
    var searchText: String?
    var type: SearchType?

    private var isNetWorkConnecting: Bool = false

    var currentItemType: SearchType = .gifs {
        didSet {
            currentItemChangeAction?(currentItemType)
        }
    }

    var startIndex: Int = 0 {
        didSet {
            scrollIndexBehaviorSubject.onNext(startIndex)
            if resultItems.count > startIndex {
                let item = resultItems[startIndex]
                currentItemType = (item.isSticker == 1 ? .stickers : .gifs)
            }
        }
    }

    func favoriteItem(isSave: Bool, index: Int) {
        let item = resultItems[index]
        if isSave {
            RealmManager.shared.saveFavoriteItem(item)
        } else {
            guard let itemID = item.itemID else { return }
            print(RealmManager.shared.removeFavoriteItem(itemID))
        }
    }

    func fetchSearchResult() {
        guard let type = type, let offset = offset, let totalCount = totalCount, let searchText = searchText else { return }
        if !isNetWorkConnecting && (totalCount < 0 || offset < totalCount) {
            isNetWorkConnecting = true
            ApiManager.searchList(type: type, keyword: searchText, limit: 20, offset: offset).response(SearchResultListModel.self, onError: { [weak self] error in
                guard let self = self else { return }
                print(error)
                self.isNetWorkConnecting = false
            }, onCompleted: { [weak self] result in
                guard let self = self else { return }
                self.totalCount = result.pagination.totalCount
                result.data.forEach { item in
                    let giphyData = item.images.downsizedMedium
                    giphyData.itemID = item.id
                    giphyData.isSticker = item.isSticker
                    self.resultItems.append(giphyData)
                }

                self.offset = self.resultItems.count
                self.resultBehaviorSubject.onNext(self.resultItems)
                self.isNetWorkConnecting = false
            }).disposed(by: disposeBag)
        }
    }
}
