//
//  BaseViewController.swift
//  GiphyList
//
//  Created by 29cm on 2020/02/24.
//

import Foundation
import RxSwift
import UIKit

class BaseViewController: UIViewController {
    lazy var disposeBag: DisposeBag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        view.backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .overFullScreen
        view.backgroundColor = .black
    }
}
