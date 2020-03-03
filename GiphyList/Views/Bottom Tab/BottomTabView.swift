//
//  BottomTabView.swift
//  GiphyList
//
//  Created by 29cm on 2020/03/03.
//

import Foundation
import RxSwift
import UIKit

typealias SelectButtonInfo = (barColor: UIColor, button: UIButton, type: BottomTabType)

enum BottomTabType: String, CaseIterable {
    case search
    case favorite
}

class BottomTabView: UIView, NibLoadable {
    private var selectBar: UIView!
    private var disposeBag: DisposeBag = DisposeBag()

    var buttonTapBehaviorSubject: BehaviorSubject<BottomTabType> = BehaviorSubject(value: .search)

    private var buttons: [UIButton] = Array()
    private var barColors: [UIColor] = [.red, .blue]
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
        var buttonCount: CGFloat = 0
        for view in subviews[0].subviews {
            if let button = view as? UIButton {
                buttonCount += 1
                setupButtonAction(button: button)
            }
        }

        let width = frame.size.width / buttonCount
        selectBar = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 5))
        selectBar.backgroundColor = .red
        addSubview(selectBar)
    }

    private func setupButtonAction(button setupButton: UIButton) {
        buttons.append(setupButton)
        setupButton.rx.tap.asDriver().map({ _ -> SelectButtonInfo? in
            for (index, button) in self.buttons.enumerated() where button == setupButton {
                var barColor: UIColor = UIColor.red
                var selectButtonType: BottomTabType = .search
                if self.barColors.count > index {
                    barColor = self.barColors[index]
                }

                for type in BottomTabType.allCases where type.rawValue == button.restorationIdentifier {
                    selectButtonType = type
                }

                self.deSelectButtons()
                return (barColor, button, selectButtonType)
            }

            return nil
        }).drive(onNext: { [weak self] selectButton in
            guard let self = self, let selectButton = selectButton else { return }
            selectButton.button.isSelected = true
            self.buttonTapBehaviorSubject.onNext(selectButton.type)
            self.moveSelectBar(selectButton)
        }).disposed(by: disposeBag)
    }

    private func deSelectButtons() {
        for button in buttons {
            button.isSelected = false
        }
    }

    private func moveSelectBar(_ info: SelectButtonInfo) {
        UIView.animate(withDuration: 0.3) {
            self.selectBar.frame.origin.x = info.button.frame.origin.x
            self.selectBar.backgroundColor = info.barColor
        }
    }
}
