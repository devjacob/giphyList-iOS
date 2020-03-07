//
//  NavigationView.swift
//  GiphyList
//
//  Created by 29cm on 2020/03/07.
//

import Foundation
import UIKit

class NavigationView: UIView, NibLoadable {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib()
        initView()
    }

    private func initView() {
    }
}
