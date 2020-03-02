//
//  SearchResultViewController.swift
//  GiphyList
//
//  Created by 정창현 on 2020/02/29.
//

import Foundation
import Kingfisher
import UIKit

class SearchResultViewController: BaseViewController {
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: SearchResultViewModel = SearchResultViewModel()

    private var headerView: SearchHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView = SearchHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: headerViewHeight))

        collectionView.register(SearchResultCell.self)

        (collectionView?.collectionViewLayout as? FlexibleLayout)?.delegate = self

        viewModel.resultBehaviorSubject.asDriver(onErrorJustReturn: nil).filter({ items -> Bool in
            items != nil
        }).drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            (self.collectionView?.collectionViewLayout as? FlexibleLayout)?.reloadData()
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = viewModel.resultItems else { return 0 }
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else {
            return UICollectionViewCell()
        }
        guard let data = viewModel.resultItems?[indexPath.row] else { return UICollectionViewCell() }

        let url = URL(string: data.images.downsizedMedium.url)
        cell.imageView.kf.setImage(with: url)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let showItemIndex = viewModel.resultItems?.count else { return }
        if indexPath.row >= (showItemIndex - 12) {
            viewModel.fetchSearchResult()
        }
    }

//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
//
//            return header
//
//        default:
//
//            print("anything")
//        }
//
//        return UICollectionReusableView()
//    }
}

extension SearchResultViewController: FlexibleLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        // 계산이 필요
        print(indexPath.row)
        guard let widthString = viewModel.resultItems?[indexPath.item].images.downsizedMedium.width, let width = NumberFormatter().number(from: widthString) as? CGFloat else { return 0.0 }
        guard let heightString = viewModel.resultItems?[indexPath.item].images.downsizedMedium.height, let height = NumberFormatter().number(from: heightString) as? CGFloat else { return 0.0 }
        let showSizeHeight = (view.frame.size.width / 2) * height / width

        return showSizeHeight
    }
}
