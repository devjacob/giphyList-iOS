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

    var resultItems: [SearchItemModel]? {
        didSet {
            guard let items = resultItems else { return }
            resultBehaviorSubject.onNext(items)
        }
    }

    func fetchSearchResult(limit: Int = 20, offset: Int = 0) {
        ApiManager.searchList(type: type, keyword: searchText, limit: limit, offset: offset).response(SearchResultListModel.self, onError: { [weak self] error in
            guard let self = self else { return }
            self.errorBehaviorSubject.onNext(error)
            print(error)
        }, onCompleted: { [weak self] result in
            guard let self = self else { return }
            if self.resultItems != nil {
                result.data.forEach { item in
                    self.resultItems?.append(item)
                }
            } else {
                self.resultItems = result.data
            }
        }).disposed(by: disposeBag)
    }
}
