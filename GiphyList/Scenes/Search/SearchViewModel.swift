//
//  SearchViewModel.swift
//  GiphyList
//
//  Created by 29cm on 2020/02/26.
//

import Foundation
import UIKit

class SearchViewModel {
    var popularSearchTexts: [SearchTextModel] = Array()

    init() {
        fetchPopularSearchText()
    }

    private func fetchPopularSearchText() {
    }

    func showSearchResultViewController(_ viewController: UIViewController, text: String, type: SearchType) {
        let searchResultViewController = SearchResultViewController(nibName: "SearchResultViewController", bundle: nil)
        searchResultViewController.viewModel.searchText = text
        searchResultViewController.viewModel.type = type
        viewController.present(searchResultViewController, animated: true, completion: nil)
    }
}
