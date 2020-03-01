//
//  SearchViewController.swift
//  GiphyList
//
//  Created by 29cm on 2020/02/26.
//

import Foundation
import UIKit

private let headerViewHeight: CGFloat = 40

class SearchViewController: BaseViewController {
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: SearchViewModel = SearchViewModel()

    private var headerView: SearchHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView = SearchHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: headerViewHeight))
        tableView.tableHeaderView = headerView

        searchBar.searchButton.rx.tap.asDriver().filter({ [weak self] _ in
            guard let self = self else { return false }
            return (self.searchBar.searchTextField.text?.count ?? 0) > 0
        }).drive(onNext: { [weak self] _ in
            guard let self = self, let text = self.searchBar.searchTextField.text else { return }
            self.viewModel.showSearchResultViewController(self, text: text, type: self.headerView.selectButton)
        }).disposed(by: disposeBag)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.popularSearchTexts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
