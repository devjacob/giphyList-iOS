//
//  FavriteViewController.swift
//  GiphyList
//
//  Created by 정창현 on 2020/03/01.
//

import Foundation
import UIKit

class FavoriteViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: FavoriteViewModel = FavoriteViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(SearchResultCell.self)
        (collectionView?.collectionViewLayout as? FlexibleLayout)?.delegate = self

        viewModel.favoriteItemsBehaviorSubject.asDriver(onErrorJustReturn: nil).filter { items -> Bool in
            items != nil
        }.drive(onNext: { _ in
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)

        collectionView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.showDetailViewController(self, index: indexPath.row)
        }).disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.fetchFavoriteList()
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = viewModel.favoriteItems else { return 0 }
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else {
            return UICollectionViewCell()
        }
        guard let data = viewModel.favoriteItems?[indexPath.row] else { return UICollectionViewCell() }

        let url = URL(string: data.url)
        cell.imageView.kf.setImage(with: url)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

extension FavoriteViewController: FlexibleLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        // 계산이 필요
        print(indexPath.row)
        guard let widthString = viewModel.favoriteItems?[indexPath.item].width, let width = NumberFormatter().number(from: widthString) as? CGFloat else { return 0.0 }
        guard let heightString = viewModel.favoriteItems?[indexPath.item].height, let height = NumberFormatter().number(from: heightString) as? CGFloat else { return 0.0 }
        let showSizeHeight = (view.frame.size.width / 2) * height / width

        return showSizeHeight
    }
}
