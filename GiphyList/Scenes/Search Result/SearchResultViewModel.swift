//
//  SearchResultViewModel.swift
//  GiphyList
//
//  Created by 정창현 on 2020/02/29.
//

import Foundation
import RxSwift

class SearchResultViewModel {
    private var disposeBag: DisposeBag = DisposeBag()

    var coordinator: NavigationCoordinator?

    var resultBehaviorSubject: BehaviorSubject<[ImageItemModel]?> = BehaviorSubject(value: nil)
    var errorBehaviorSubject: BehaviorSubject<Error?> = BehaviorSubject(value: nil)

    var searchText: String = "" {
        didSet {
            totalCount = -1
            offset = 0
            resultItems.removeAll()
        }
    }

    var type: SearchType = .gifs {
        didSet {
            totalCount = -1
            offset = 0
            resultItems.removeAll()
        }
    }

    var offset: Int = 0
    private var totalCount: Int = -1

    private var isNetWorkConnecting: Bool = false
    var resultItems: [ImageItemModel] = Array()

    func fetchSearchResult(limit: Int = 20) {
        if !isNetWorkConnecting && (totalCount < 0 || offset < totalCount) {
            isNetWorkConnecting = true
            ApiManager.searchList(type: type, keyword: searchText, limit: limit, offset: offset).response(SearchResultListModel.self, onError: { [weak self] error in
                guard let self = self else { return }
                self.errorBehaviorSubject.onNext(error)
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

    func changeType(type clickType: SearchType) {
        if type != clickType {
            type = clickType
            resultItems.removeAll()
            totalCount = -1
            offset = 0
            fetchSearchResult()
        }
    }

    func data(searchText: String, type: SearchType) {
        self.searchText = searchText
        self.type = type
        fetchSearchResult()
    }

    func showDetailViewController(_ viewController: UIViewController, index: Int) {
        guard index < resultItems.count else { return }
        coordinator?.showDetailViewController(items: resultItems, startIndex: index, searchText: searchText, offset: offset, totalCount: totalCount, type: type)
    }

    func showSearchResultViewController(text: String) {
        coordinator?.showSearchResultViewController(text: text, type: type)
    }
}
