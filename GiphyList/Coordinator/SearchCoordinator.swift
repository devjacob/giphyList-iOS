//
//  SearchCoordinator.swift
//  GiphyList
//
//  Created by 29cm on 2020/03/07.
//

import Foundation
import RxSwift

class SearchCoordinator {
    var rootViewController: BaseNavigationController!

    init() {
        let viewController = SearchResultViewController(nibName: "SearchResultViewController", bundle: nil)

        viewController.viewModel.coordinator = self

        let rootVC = BaseNavigationController(rootViewController: viewController)
        rootVC.isNavigationBarHidden = true
        rootVC.interactivePopGestureRecognizer?.delegate = nil
        rootVC.navigationDelegate = self
        rootViewController = rootVC
    }

    init(frame: CGRect, viewController: BaseViewController) {
        viewController.view.frame.size = frame.size

        let rootVC = BaseNavigationController(rootViewController: viewController)
        rootVC.isNavigationBarHidden = true
        rootVC.interactivePopGestureRecognizer?.delegate = nil
        rootVC.navigationDelegate = self
        rootViewController = rootVC
        rootViewController.view.frame.size = frame.size
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showDetailViewController(items: [The480_WStill], startIndex: Int) {
        let detailViewController = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailViewController.view.frame.size = rootViewController.view.frame.size
        detailViewController.viewModel.coordinator = self
        detailViewController.viewModel.resultItems = items
        detailViewController.viewModel.startIndex = startIndex

        rootViewController.pushViewController(detailViewController, animated: true)
    }

    func showSearchViewController() {
        let searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        searchViewController.view.frame.size = rootViewController.view.frame.size
        searchViewController.viewModel.coordinator = self
        rootViewController.pushViewController(searchViewController, animated: true)
    }

    func showSearchResultViewController(text: String, type: SearchType) {
        let searchResultViewController = SearchResultViewController(nibName: "SearchResultViewController", bundle: nil)
        searchResultViewController.viewModel.data(searchText: text, type: type)
        searchResultViewController.view.frame.size = rootViewController.view.frame.size
        searchResultViewController.viewModel.coordinator = self
        rootViewController.pushViewController(searchResultViewController, animated: true)
    }

    func popViewController(_ animated: Bool = true) {
        rootViewController.popViewController(animated: animated)
    }
}

extension SearchCoordinator: NavigationControllerDelegate {
    func showViewController(_ currentViewController: UIViewController) {
    }
}
