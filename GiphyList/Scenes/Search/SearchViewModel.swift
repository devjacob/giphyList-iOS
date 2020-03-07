//
//  SearchViewModel.swift
//  GiphyList
//
//  Created by 29cm on 2020/02/26.
//

import Foundation
import UIKit

class SearchViewModel {
    var coordinator: SearchCoordinator?
    
    var popularSearchTexts: [SearchTextModel] = Array()

    init() {
        fetchPopularSearchText()
    }

    private func fetchPopularSearchText() {
    }

    func showSearchResultViewController(text: String, type: SearchType) {
        coordinator?.showSearchResultViewController(text: text, type: type)
    }
}
