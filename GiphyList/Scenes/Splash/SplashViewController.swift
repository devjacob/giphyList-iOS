//
//  SplashViewController.swift
//  GiphyList
//
//  Created by 29cm on 2020/02/24.
//

import Foundation

class SplashViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            let viewController = MainTabViewController(nibName: "MainTabViewController", bundle: nil)
            self.present(viewController, animated: true, completion: nil)
        }
    }
}
