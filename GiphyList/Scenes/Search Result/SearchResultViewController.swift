//
//  SearchResultViewController.swift
//  GiphyList
//
//  Created by 정창현 on 2020/02/29.
//

import Foundation
import UIKit

class SearchResultViewController: BaseViewController {
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: SearchResultViewModel = SearchResultViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchSearchResult()
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = viewModel.resultItems else { return 0 }
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}
