//
//  BaseNavigationViewController.swift
//  GiphyList
//
//  Created by 29cm on 2020/03/07.
//

import Foundation
import RxSwift
import UIKit

typealias ViewControllerType = (isFirst: Bool, moveType: ViewMoveType, viewController: UIViewController?)

enum ViewMoveType {
    case tab
    case push
    case pop
}

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    lazy var viewChangeBehaviorSubject: BehaviorSubject<ViewControllerType?> = BehaviorSubject(value: nil)

    var lastViewControllerType: ViewControllerType? {
        didSet {
            viewChangeBehaviorSubject.onNext(lastViewControllerType)
        }
    }

    weak var navigationDelegate: NavigationControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func navigationController(_ navigationController: UIKit.UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationDelegate?.showViewController(viewController)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        if viewControllers.count > 1 {
            lastViewControllerType = (false, .push, viewController)
        } else {
            lastViewControllerType = (true, .push, viewController)
        }
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        let viewController = super.popViewController(animated: animated)
        if viewControllers.count > 1 {
            lastViewControllerType = (false, .pop, viewControllers.last)
        } else {
            lastViewControllerType = (true, .pop, viewControllers.last)
        }

        return viewController
    }
}

protocol NavigationControllerDelegate: class {
    func showViewController(_ currentViewController: UIViewController)
}
