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

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerNib = UINib(nibName: "CollectionViewHeader", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader")
        collectionView.register(SearchResultCell.self)

        if let layout = collectionView?.collectionViewLayout as? FlexibleLayout {
            layout.delegate = self
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: headerViewHeight)
            layout.sectionHeadersPinToVisibleBounds = true
        }

        viewModel.resultBehaviorSubject.asDriver(onErrorJustReturn: nil).filter({ items -> Bool in
            items != nil
        }).drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)

        searchBar.searchButton.rx.tap.asDriver().filter({ [weak self] _ in
            guard let self = self else { return false }
            return (self.searchBar.searchTextField.text?.count ?? 0) > 0
        }).drive(onNext: { [weak self] _ in
            guard let self = self, let text = self.searchBar.searchTextField.text else { return }
            self.viewModel.showSearchResultViewController(text: text)
        }).disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchBar.searchTextField.text = viewModel.searchText
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.resultItems.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else {
            return UICollectionViewCell()
        }
        let data = viewModel.resultItems[indexPath.row]
        let url = URL(string: data.url)
        cell.imageView.kf.setImage(with: url)
        if data.isSticker == 1 {
            cell.backgroundColor = .lightGray
        } else {
            cell.backgroundColor = data.backgroundColor()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let showItemIndex = viewModel.resultItems.count
        if indexPath.row >= (showItemIndex - 12) {
            viewModel.fetchSearchResult()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showDetailViewController(self, index: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewHeader", for: indexPath) as? CollectionViewHeader {
                headerView.buttonChangePublishSubject.asDriver(onErrorJustReturn: .gifs).drive(onNext: { [weak self] type in
                    guard let self = self else { return }
                    self.viewModel.changeType(type: type)
                }).disposed(by: headerView.disposeBag)
                return headerView
            }
        }
        return UICollectionReusableView()
    }
}

extension SearchResultViewController: FlexibleLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        let widthString = viewModel.resultItems[indexPath.item].width
        let heightString = viewModel.resultItems[indexPath.item].height
        guard let width = NumberFormatter().number(from: widthString) as? CGFloat else { return 0.0 }
        guard let height = NumberFormatter().number(from: heightString) as? CGFloat else { return 0.0 }
        let showSizeHeight = (view.frame.size.width / 2) * height / width

        return showSizeHeight
    }
}
