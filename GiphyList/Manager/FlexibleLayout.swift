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

class FlexibleLayout: UICollectionViewFlowLayout {
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
        leftHeight = 0
        rightHeight = 0
        cache.removeAll()

        if headerReferenceSize.height > 0 {
            leftHeight += headerReferenceSize.height
            rightHeight += headerReferenceSize.height
        }

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            guard cache.count <= item else { continue }
            let indexPath = IndexPath(item: item, section: 0)

            guard let imageHeight = delegate?.collectionView(collectionView, heightForCellAtIndexPath: indexPath) else { return }
            let height = cellPadding * 2 + imageHeight
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
        let sections = NSMutableIndexSet()
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = Array()

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)

                if attributes.representedElementCategory == .cell {
                    sections.add(attributes.indexPath.section)

                } else if attributes.representedElementCategory == .supplementaryView {
                    sections.add(attributes.indexPath.section)
                }
            }
        }

        for section in sections {
            let indexPath = IndexPath(item: 0, section: section)

            if let sectionAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                visibleLayoutAttributes.append(sectionAttributes)
            }
        }

        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        attributes.frame.size = headerReferenceSize

        return attributes
    }
}
