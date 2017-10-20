//
//  PageSliderLayout.swift
//  PageSlider
//
//  Created by Oleksandr Glagoliev on 10/20/17.
//  Copyright © 2017 Oleksandr Glagoliev. All rights reserved.
//

import UIKit

class PageSliderLayout: UICollectionViewLayout {
    fileprivate var attributesCache = [IndexPath: UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        attributesCache = [IndexPath: UICollectionViewLayoutAttributes]()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard  let collectionView = self.collectionView else {
            return nil
        }
        
        var updatedAttributes = [UICollectionViewLayoutAttributes]()
        let sectionsCount = collectionView.numberOfSections
        
        for section in 0..<sectionsCount {
            let rowsCount = collectionView.numberOfItems(inSection: section)
            
            for row in 0..<rowsCount {
                let indexPath = IndexPath(row: row, section: section)
                
                if let itemAttrs = layoutAttributesForItem(at: indexPath)  {
                    if itemAttrs.frame.intersects(rect) {
                        updatedAttributes.append(itemAttrs)
                    }
                }
            }
        }
        
        return updatedAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collView = collectionView else {
            return false
        }
        let oldBounds = collView.bounds
        return oldBounds != newBounds
    }
    
    // Helpers
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attrs = attributesCache[indexPath] {
            return attrs
        }
        
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        if let collectionView = self.collectionView {
            let x: CGFloat = CGFloat(indexPath.row) * collectionView.bounds.width
            let y: CGFloat = 0
            let w: CGFloat = collectionView.bounds.width
            let h: CGFloat = collectionView.bounds.height
            layoutAttributes.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        
        attributesCache[indexPath] = layoutAttributes
        return layoutAttributes
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return CGSize.zero
        }
        let w = CGFloat(collectionView.numberOfItems(inSection: 0)) * collectionView.bounds.size.width
        let h = collectionView.bounds.size.height
        return CGSize(width: w, height: h)
    }
}
