//
//  UICollectionView+Extension.swift
//  GiphyList
//
//  Created by 정창현 on 2020/02/29.
//

import Foundation
import UIKit

extension UICollectionView {
    func register<T>(_ nib: T.Type) {
        let nibName = "\(nib.self)"
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: nibName)
    }
}
