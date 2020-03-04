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
    
    var viewModel: MainTabViewModel = MainTabViewModel()

    var searchViewController: SearchViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        searchViewController.view.frame.size = contentView.frame.size

        bottomTabView.buttonTapBehaviorSubject.asDriver(onErrorJustReturn: .search).drive(onNext: { [weak self] type in
            guard let self = self else { return }
            self.changeViewController(type)
        }).disposed(by: disposeBag)
    }

    private func changeViewController(_ type: BottomTabType) {
        switch type {
        case .search:
            contentView.addSubview(searchViewController.view)
        case .favorite:
            break
        }
    }
}
