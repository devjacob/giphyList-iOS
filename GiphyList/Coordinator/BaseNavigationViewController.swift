//
//  BaseNavigationViewController.swift
//  GiphyList
//
//  Created by 29cm on 2020/03/07.
//

import Foundation
import RxSwift
import UIKit

typealias ViewControllerType = (isFirst: Bool, viewController: UIViewController?)

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    lazy var viewChangeBehaviorSubject: BehaviorSubject<ViewControllerType?> = BehaviorSubject(value: nil)

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
            viewChangeBehaviorSubject.onNext((false, viewController))
        } else {
            viewChangeBehaviorSubject.onNext((true, viewController))
        }
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        let viewController = super.popViewController(animated: animated)
        if viewControllers.count > 1 {
            viewChangeBehaviorSubject.onNext((false, viewController))
        } else {
            viewChangeBehaviorSubject.onNext((true, viewController))
        }

        return viewController
    }

//    func navigationController(
//        _ navigationController: UIKit.UINavigationController,
//        animationControllerFor operation: UINavigationController.Operation,
//        from fromVC: UIViewController,
//        to toVC: UIViewController
//    ) -> UIViewControllerAnimatedTransitioning? {
//        var animator: PresentStylePushPopAnimator?
//        if let vc = fromVC as? RelatedContentViewController,
//            toVC is TVPlayerViewController {
//            animator = PresentStylePushPopAnimator(
//                pushing: false,
//                dimmedView: vc.dimmedView,
//                contentView: vc.contentView
//            )
//        }
//
//        if let vc = toVC as? RelatedContentViewController,
//            fromVC is TVPlayerViewController {
//            animator = PresentStylePushPopAnimator(
//                pushing: true,
//                dimmedView: vc.dimmedView,
//                contentView: vc.contentView
//            )
//        }
//
//        return animator
//    }
}

protocol NavigationControllerDelegate: class {
    func showViewController(_ currentViewController: UIViewController)
}
