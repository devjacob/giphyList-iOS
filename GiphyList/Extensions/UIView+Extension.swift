//
//  UIView+Extension.swift
//  GiphyList
//
//  Created by 29cm on 2020/02/26.
//

import Foundation
import UIKit

extension UIView {
    func setEdgeConstraints(to view: UIView, top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
        NSLayoutConstraint.activate([self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
                                     self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: right),
                                     self.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
                                     self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)])
    }
}
