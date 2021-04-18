//
//  NewsFeedPhotoCollectionLayout.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 4/16/21.
//  Copyright © 2021 Nikolay Gutorov. All rights reserved.
//

import UIKit

protocol NewsFeedPhotoCollectionLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize
}

class NewsFeedPhotoCollectionLayout: UICollectionViewLayout {
    
    weak var delegate: NewsFeedPhotoCollectionLayoutDelegate!
    
    static var numberOfRows = 2
    fileprivate var cellPadding: CGFloat = 8
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentWidth: CGFloat = 0
    
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.left + insets.right)
    }
    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        contentWidth = 0
        cache = []
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        
        var photoSizes = [CGSize]()
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoSize = delegate.collectionView(collectionView, photoAtIndexPath: indexPath)
            photoSizes.append(photoSize)
        }
        
        let superViewWidth = collectionView.frame.width
        
        guard var rowHeight = NewsFeedPhotoCollectionLayout.countRowHeight(superViewWidth: superViewWidth, photoSizes: photoSizes) else { return }
        
        rowHeight = rowHeight / CGFloat(NewsFeedPhotoCollectionLayout.numberOfRows)
        
        let photoRatios = photoSizes.map { $0.height / $0.width }
        
        var yOffset = [CGFloat]()
        
        for row in 0 ..< NewsFeedPhotoCollectionLayout.numberOfRows {
            yOffset.append(CGFloat(row) * rowHeight)
        }
        
        var xOffset  = [CGFloat](repeating: 0, count: NewsFeedPhotoCollectionLayout.numberOfRows)
        
        var row = 0
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let ratio = photoRatios[indexPath.row]
            let width = rowHeight / ratio
            let frame = CGRect(x: xOffset[row], y: yOffset[row], width: width, height: rowHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            cache.append(attribute)
            
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] += width
            row = row < (NewsFeedPhotoCollectionLayout.numberOfRows - 1) ? (row + 1) : 0
        }
    }
    
    static func countRowHeight(superViewWidth: CGFloat, photoSizes: [CGSize]) -> CGFloat? {
        var rowHeight: CGFloat
        
        let photoWidthMinRatioOptional = photoSizes.min { (first, second) -> Bool in
            (first.height / first.width) < (second.height / second.width)
        }
        
        guard let photoWidthMinRatio = photoWidthMinRatioOptional else { return nil }
        
        let difference = superViewWidth / photoWidthMinRatio.width
        
        rowHeight = photoWidthMinRatio.height * difference
        rowHeight = rowHeight * CGFloat(NewsFeedPhotoCollectionLayout.numberOfRows)
        return rowHeight
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
}
