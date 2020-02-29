//
//  SearchHeaderView.swift
//  GiphyList
//
//  Created by 29cm on 2020/02/26.
//

import Foundation
import UIKit

class SearchHeaderView: UIView, NibLoadable {
    @IBOutlet weak var gifsButton: UIButton!
    @IBOutlet weak var stickersButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    
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
