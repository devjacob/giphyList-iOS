//
//  UITableView+Extension.swift
//  GiphyList
//
//  Created by 29cm on 2020/02/26.
//

import Foundation
import UIKit

extension UITableView {
    func register<T>(_ nib: T.Type) {
        let nibName = "\(nib.self)"
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: nibName)
    }
}
