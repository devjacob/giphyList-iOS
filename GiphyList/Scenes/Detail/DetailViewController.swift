//
//  DetailViewController.swift
//  GiphyList
//
//  Created by 29cm on 2020/03/04.
//

import Foundation
import FSPagerView
import RxSwift
import UIKit

class DetailViewController: BaseViewController {
    @IBOutlet weak var gifsCollectionView: FSPagerView! {
        didSet {
            gifsCollectionView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var descriptionView: UIView!

    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!

    var viewModel: DetailViewModel = DetailViewModel()

    var indexasd: Int = 0

    @IBAction func favoriteButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.favoriteItem(isSave: sender.isSelected, index: gifsCollectionView.currentIndex)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        gifsCollectionView.transformer = FSPagerViewTransformer(type: .overlap)
        gifsCollectionView.itemSize = CGSize(width: 200, height: 200)
        gifsCollectionView.isInfinite = false
        viewModel.scrollIndexBehaviorSubject.asDriver(onErrorJustReturn: 0).drive(onNext: { index in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.cellHeight(index: index)
                self.gifsCollectionView.scrollToItem(at: index, animated: false)
                self.gifsCollectionView.isHidden = false
                self.descriptionView.isHidden = false
                self.description(index: index)
            }
        }).disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func cellHeight(index: Int) {
        guard let item = self.viewModel.resultItems?[index] else { return }
        guard let imageHeight = NumberFormatter().number(from: item.height) as? CGFloat else { return }
        guard let imageWidth = NumberFormatter().number(from: item.width) as? CGFloat else { return }

        let width = gifsCollectionView.frame.size.width - 30
        let height = width * imageHeight / imageWidth
        gifsCollectionView.itemSize = CGSize(width: width, height: height)

        UIView.animate(withDuration: 0.5) {
            self.collectionViewHeight.constant = height
        }
    }

    private func description(index: Int) {
        guard let item = self.viewModel.resultItems?[index] else { return }
        favoriteButton.isSelected = item.isFavorite()
    }
}

extension DetailViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        guard let count = viewModel.resultItems?.count else { return 0 }
        return count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        guard let data = viewModel.resultItems?[index] else { return FSPagerViewCell() }

        let url = URL(string: data.url)

        cell.imageView?.kf.setImage(with: url)
        cell.imageView?.contentMode = .scaleToFill
        if data.isSticker == 1 {
            cell.backgroundColor = .lightGray
        } else {
            cell.backgroundColor = data.backgroundColor()
        }

        return cell
    }

    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        cellHeight(index: pagerView.currentIndex)
        description(index: pagerView.currentIndex)

        guard let data = viewModel.resultItems?[pagerView.currentIndex] else { return }
        viewModel.currentItemType = (data.isSticker == 1 ? .stickers : .gifs)
    }
}
