//
//  CollectionViewHeader.swift
//  GiphyList
//
//  Created by 29cm on 2020/03/08.
//

import Foundation
import RxSwift
import UIKit

class CollectionViewHeader: UICollectionReusableView {
//    var searchHeaderView: SearchHeaderView?

    var disposeBag: DisposeBag = DisposeBag()

    var buttonChangePublishSubject: PublishSubject<SearchType> = PublishSubject()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
        let searchHeaderView = SearchHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: headerViewHeight))
        searchHeaderView.buttonChangeBehaviorSubject.asDriver(onErrorJustReturn: .gifs).drive(onNext: { [weak self] type in
            guard let self = self else { return }
            self.buttonChangePublishSubject.onNext(type)
        }).disposed(by: searchHeaderView.disposeBag)
        addSubview(searchHeaderView)
    }
}
