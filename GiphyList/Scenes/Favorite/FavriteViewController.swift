//
//  FavriteViewController.swift
//  GiphyList
//
//  Created by 정창현 on 2020/03/01.
//

import Foundation
import UIKit

class FavoriteViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: FavoriteViewModel = FavoriteViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel.favoriteList()
    }
}
