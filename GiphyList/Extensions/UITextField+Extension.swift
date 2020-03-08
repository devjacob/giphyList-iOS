//
//  UI.swift
//  GiphyList
//
//  Created by 정창현 on 2020/02/29.
//

import Foundation
import UIKit

enum PaddingLocation {
    case left
    case right
}

extension UITextField {
    func leftRightPaddingPoint(_ padding: [PaddingLocation], point: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: point, height: frame.size.height))
        for location in padding {
            switch location {
            case .left:
                leftView = paddingView
                leftViewMode = .always
            case .right:
                rightView = paddingView
                rightViewMode = .always
            }
        }
    }
}
