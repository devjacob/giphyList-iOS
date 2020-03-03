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
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = viewModel.favoriteList else { return 0 }
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else {
            return UICollectionViewCell()
        }
        guard let data = viewModel.favoriteList?[indexPath.row] else { return UICollectionViewCell() }

        let url = URL(string: data.images.downsizedMedium.url)
        cell.imageView.kf.setImage(with: url)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let showItemIndex = viewModel.resultItems?.count else { return }
//        if indexPath.row >= (showItemIndex - 12) {
//            viewModel.fetchSearchResult()
//        }
    }
}

extension FavoriteViewController: FlexibleLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        // 계산이 필요
        print(indexPath.row)
        guard let widthString = viewModel.favoriteList?[indexPath.item].images.downsizedMedium.width, let width = NumberFormatter().number(from: widthString) as? CGFloat else { return 0.0 }
        guard let heightString = viewModel.favoriteList?[indexPath.item].images.downsizedMedium.height, let height = NumberFormatter().number(from: heightString) as? CGFloat else { return 0.0 }
        let showSizeHeight = (view.frame.size.width / 2) * height / width

        return showSizeHeight
    }
}
