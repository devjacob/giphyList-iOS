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

    var searchCoordinator: SearchCoordinator!
    var favoriteCoordinator: SearchCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        searchCoordinator = SearchCoordinator(frame: contentView.frame, viewController: searchViewController)
        searchViewController.viewModel.coordinator = searchCoordinator
        searchCoordinator.rootViewController.viewChangeBehaviorSubject.asDriver(onErrorJustReturn: nil).filter { type -> Bool in
            type != nil
        }.drive(onNext: { [weak self] viewControllerType in
            guard let self = self else { return }
            self.navigationView.backButton.isHidden = viewControllerType?.isFirst ?? true
            if let _ = (viewControllerType?.viewController as? DetailViewController) {
                self.navigationView.searchButton.isHidden = false
            } else {
                self.navigationView.searchButton.isHidden = true
            }

            if let viewController = viewControllerType?.viewController as? SearchResultViewController {
                let searchText = viewController.viewModel.searchText
                self.navigationView.titleLabel.text = searchText
            }
        }).disposed(by: disposeBag)

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

        let favoriteViewController = FavoriteViewController(nibName: "FavoriteViewController", bundle: nil)

        favoriteCoordinator = SearchCoordinator(frame: contentView.frame, viewController: favoriteViewController)
        favoriteViewController.viewModel.coordinator = favoriteCoordinator
        favoriteCoordinator.rootViewController.viewChangeBehaviorSubject.asDriver(onErrorJustReturn: nil).filter { type -> Bool in
            type != nil
        }.drive(onNext: { [weak self] viewControllerType in
            guard let self = self else { return }
            self.navigationView.backButton.isHidden = viewControllerType?.isFirst ?? true
        }).disposed(by: disposeBag)

        bottomTabView.buttonTapBehaviorSubject.asDriver(onErrorJustReturn: .search).drive(onNext: { [weak self] type in
            guard let self = self else { return }
            self.viewModel.tapType = type
            self.changeViewController(type)
        }).disposed(by: disposeBag)
    }

    private func changeViewController(_ type: BottomTabType) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        switch type {
        case .search:
            contentView.addSubview(searchCoordinator.rootViewController.view)
            searchCoordinator.rootViewController.didMove(toParent: self)
        case .favorite:
            contentView.addSubview(favoriteCoordinator.rootViewController.view)
            favoriteCoordinator.rootViewController.didMove(toParent: self)
        }
    }
}
