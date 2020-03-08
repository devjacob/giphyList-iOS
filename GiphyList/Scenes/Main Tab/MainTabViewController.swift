//
//  BottomTabViewController.swift
//  GiphyList
//
//  Created by 29cm on 2020/03/03.
//

import Foundation
import UIKit

class MainTabViewController: BaseViewController {
    @IBOutlet weak var bottomTabView: BottomTabView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var navigationView: NavigationView!

    var viewModel: MainTabViewModel = MainTabViewModel()

    var searchCoordinator: NavigationCoordinator!
    var favoriteCoordinator: NavigationCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.backButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            switch self.viewModel.tapType {
            case .search:
                _ = self.searchCoordinator.popViewController()
            case .favorite:
                _ = self.favoriteCoordinator.popViewController()
            }
        }).disposed(by: disposeBag)

        navigationView.searchButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            switch self.viewModel.tapType {
            case .search:
                self.searchCoordinator.showSearchViewController()
            case .favorite:
                self.favoriteCoordinator.showSearchViewController()
            }
        }).disposed(by: disposeBag)

        let searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        searchCoordinator = NavigationCoordinator(frame: contentView.frame, viewController: searchViewController)
        searchViewController.viewModel.coordinator = searchCoordinator
        coordinatorAction(coordinator: searchCoordinator)

        let favoriteViewController = FavoriteViewController(nibName: "FavoriteViewController", bundle: nil)

        favoriteCoordinator = NavigationCoordinator(frame: contentView.frame, viewController: favoriteViewController)
        favoriteViewController.viewModel.coordinator = favoriteCoordinator
        coordinatorAction(coordinator: favoriteCoordinator)

        bottomTabView.buttonTapBehaviorSubject.asDriver(onErrorJustReturn: .search).drive(onNext: { [weak self] type in
            guard let self = self else { return }
            self.viewModel.tapType = type
            self.changeViewController(type)
        }).disposed(by: disposeBag)
    }

    private func coordinatorAction(coordinator: NavigationCoordinator) {
        coordinator.rootViewController.viewChangeBehaviorSubject.asDriver(onErrorJustReturn: nil).filter { type -> Bool in
            type != nil
        }.drive(onNext: { [weak self] viewControllerType in
            guard let self = self, let viewControllerType = viewControllerType else { return }
            self.viewChangeStatus(viewControllerType)
        }).disposed(by: disposeBag)

        coordinator.currentItemChangePublishSubject.asDriver(onErrorJustReturn: .gifs).drive(onNext: { [weak self] type in
            guard let self = self else { return }
            var searchText: String = ""
            switch type {
            case .gifs:
                searchText = "GIF"
            case .stickers:
                searchText = "Sticker"
            case .text:
                searchText = "Sticker"
            }
            self.navigationView.titleLabel.text = searchText
        }).disposed(by: disposeBag)
    }

    private func changeViewController(_ type: BottomTabType) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        var lastViewControllerType: ViewControllerType?

        switch type {
        case .search:
            contentView.addSubview(searchCoordinator.rootViewController.view)
            searchCoordinator.rootViewController.didMove(toParent: self)
            lastViewControllerType = searchCoordinator.rootViewController.lastViewControllerType
        case .favorite:
            contentView.addSubview(favoriteCoordinator.rootViewController.view)
            favoriteCoordinator.rootViewController.didMove(toParent: self)
            lastViewControllerType = favoriteCoordinator.rootViewController.lastViewControllerType
        }

        viewChangeStatus((lastViewControllerType?.isFirst ?? true, .tab, lastViewControllerType?.viewController))
    }
}

extension MainTabViewController {
    private func viewChangeStatus(_ viewControllerType: ViewControllerType) {
        navigationView.backButton.isHidden = viewControllerType.isFirst
        navigationView.searchButton.isHidden = isSearchButtonHidden(viewControllerType.viewController)

        setupNavigationTitle(viewController: viewControllerType.viewController)

        titleAnimation(moveType: viewControllerType.moveType)
    }

    private func setupNavigationTitle(viewController currentViewController: UIViewController?) {
        guard let vc = currentViewController else { return }
        var searchText: String = ""
        if let viewController = vc as? SearchResultViewController {
            searchText = viewController.viewModel.searchText
        } else if let viewController = vc as? DetailViewController {
            switch viewController.viewModel.currentItemType {
            case .gifs:
                searchText = "GIF"
            case .stickers:
                searchText = "Sticker"
            case .text:
                searchText = "Sticker"
            }

        } else if vc is SearchViewController {
            searchText = "검색"
        } else if vc is FavoriteViewController {
            searchText = "즐겨찾기"
        }

        navigationView.titleLabel.text = searchText
    }

    private func isSearchButtonHidden(_ viewController: UIViewController?) -> Bool {
        guard let viewController = viewController else { return true }
        if viewController is DetailViewController {
            return false
        } else if viewController is FavoriteViewController {
            return false
        } 

        return true
    }

    private func titleAnimation(moveType: ViewMoveType) {
        switch moveType {
        case .pop:
            navigationView.titleLabel.transform = CGAffineTransform(translationX: 0, y: -50)
            UIView.animate(withDuration: 0.25) {
                self.navigationView.titleLabel.transform = .identity
            }
        case .push:
            navigationView.titleLabel.transform = CGAffineTransform(translationX: 0, y: 50)
            UIView.animate(withDuration: 0.25) {
                self.navigationView.titleLabel.transform = .identity
            }
        case .tab:
            break
        }
    }
}
