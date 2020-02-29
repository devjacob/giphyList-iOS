//
//  UIView+NibLoadable.swift
//  GiphyList
//
//  Created by 29cm on 2020/02/26.
//

import Foundation
import UIKit

protocol NibLoadable: class {
    func fromNib() -> UIView?
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {
    @discardableResult
    func fromNib() -> UIView? {
        if let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.setEdgeConstraints(to: self)
            return contentView
        }

        return nil
    }

    static var nibName: String {
        guard let name = String(describing: self).components(separatedBy: ".").last else { return "" }
        return name
    }

    static func fromNib<T: UIView>(_ owner: Any? = nil) -> T {
        guard let view = Bundle.main.loadNibNamed(String(describing: self), owner: owner, options: nil)![0] as? T else {
            let className = String(describing: T.self)
            fatalError("cannot create " + "\(className)")
        }
        return view as T
    }

    static func fromNib<T: UIView>(_ owner: Any? = nil, index: Int) -> T {
        guard let view = Bundle.main.loadNibNamed(String(describing: self), owner: owner, options: nil)![index] as? T else {
            let className = String(describing: T.self)
            fatalError("cannot create " + "\(className)")
        }
        return view as T
    }
}
