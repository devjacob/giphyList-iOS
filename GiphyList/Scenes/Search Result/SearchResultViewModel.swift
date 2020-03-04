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

    var resultBehaviorSubject: BehaviorSubject<[SearchItemModel]?> = BehaviorSubject(value: nil)
    var errorBehaviorSubject: BehaviorSubject<Error?> = BehaviorSubject(value: nil)

    var searchText: String = ""
    var type: SearchType = .gifs

    var offset: Int = 0

    private var isNetWorkConnecting: Bool = false
    var resultItems: [SearchItemModel]?

    func fetchSearchResult(limit: Int = 20) {
        if !isNetWorkConnecting {
            isNetWorkConnecting = true
            ApiManager.searchList(type: type, keyword: searchText, limit: limit, offset: offset).response(SearchResultListModel.self, onError: { [weak self] error in
                guard let self = self else { return }
                self.errorBehaviorSubject.onNext(error)
                print(error)
                self.isNetWorkConnecting = false
            }, onCompleted: { [weak self] result in
                guard let self = self else { return }
                if self.resultItems != nil {
                    result.data.forEach { item in
                        self.resultItems?.append(item)
                    }
                } else {
                    self.resultItems = result.data
                }

                self.offset = self.resultItems?.count ?? 0
                self.resultBehaviorSubject.onNext(self.resultItems)
                self.isNetWorkConnecting = false
            }).disposed(by: disposeBag)
        }
    }

    func data(searchText: String, type: SearchType) {
        self.searchText = searchText
        self.type = type
        fetchSearchResult()
    }

    func showDetailViewController(_ viewController: UIViewController, index: Int) {
        guard let model = resultItems?[index] else { return }
        
    }
}
