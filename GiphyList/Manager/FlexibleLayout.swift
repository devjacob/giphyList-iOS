//
//  flexibleLayout.swift
//  GiphyList
//
//  Created by 정창현 on 2020/03/01.
//

import Foundation
import UIKit

protocol FlexibleLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat
}

class FlexibleLayout: UICollectionViewLayout {
    weak var delegate: FlexibleLayoutDelegate?

    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 6

    private var cache: [UICollectionViewLayoutAttributes] = Array()

    private var leftHeight: CGFloat = 0
    private var rightHeight: CGFloat = 0

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }

        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: rightHeight < leftHeight ? leftHeight : rightHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            guard cache.count <= item else { continue }
            let indexPath = IndexPath(item: item, section: 0)

            guard let photoHeight = delegate?.collectionView(collectionView, heightForCellAtIndexPath: indexPath) else { return }
            let height = cellPadding * 2 + photoHeight
            let origin = cellOrigin()
            let frame = CGRect(origin: origin, size: CGSize(width: columnWidth, height: height))
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            updateContentHeight(height)
        }
    }

    private func updateContentHeight(_ height: CGFloat) {
        if rightHeight < leftHeight {
            rightHeight = rightHeight + height
        } else {
            leftHeight = leftHeight + height
        }
    }

    private func cellOrigin() -> CGPoint {
        if rightHeight < leftHeight {
            return CGPoint(x: contentWidth / 2.0, y: rightHeight)
        }

        return CGPoint(x: cellPadding, y: leftHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = Array()

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
