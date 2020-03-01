//
//  FavoriteSectionView.swift
//  GiphyList
//
//  Created by 정창현 on 2020/03/01.
//

import Foundation
import UIKit

class FavoriteSectionView: UIView, NibLoadable {
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
