//
//  SearchHeaderView.swift
//  GiphyList
//
//  Created by 29cm on 2020/02/26.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum SearchType: String {
    case gifs
    case stickers
    case text
}

private let selectButtonColor: UIColor = UIColor(hex: "#74F9A1")

class SearchHeaderView: UIView, NibLoadable {
    @IBOutlet weak var gifsButton: UIButton!
    @IBOutlet weak var stickersButton: UIButton!
    @IBOutlet weak var textButton: UIButton!

    private var disposeBag: DisposeBag = DisposeBag()

    var selectButton: SearchType = .gifs

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
        gifsButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.changeButtonStatus(selectButton: .gifs)
        }).disposed(by: disposeBag)

        stickersButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.changeButtonStatus(selectButton: .stickers)
        }).disposed(by: disposeBag)

        textButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.changeButtonStatus(selectButton: .text)
        }).disposed(by: disposeBag)
    }

    private func changeButtonStatus(selectButton button: SearchType) {
        initTabButtons()
        selectButton = button
        switch button {
        case .gifs:
            gifsButton.isSelected = true
            gifsButton.backgroundColor = selectButtonColor
        case .stickers:
            stickersButton.isSelected = true
            stickersButton.backgroundColor = selectButtonColor
        case .text:
            textButton.isSelected = true
            textButton.backgroundColor = selectButtonColor
        }
    }

    private func initTabButtons() {
        gifsButton.isSelected = false
        stickersButton.isSelected = false
        textButton.isSelected = false
        
        gifsButton.backgroundColor = UIColor(hex: "")
        stickersButton.backgroundColor = UIColor(hex: "")
        textButton.backgroundColor = UIColor(hex: "")
    }
}
