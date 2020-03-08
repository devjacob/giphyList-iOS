//
//  SearchBar.swift
//  GiphyList
//
//  Created by 정창현 on 2020/02/29.
//

import Foundation
import UIKit

class SearchBar: UIView, NibLoadable {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!

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
        searchTextField.leftRightPaddingPoint([.left, .right], point: 10)
    }
}
