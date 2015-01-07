//
//  BubblesCollectionViewLayout.swift
//  Bubbles Collection
//
//  Created by Jelle Vandenbeeck on 07/01/15.
//  Copyright (c) 2015 Fousa. All rights reserved.
//

import UIKit

let BubblesCollectionViewLayoutBubbleAddSize: CGFloat = 60.0
let BubblesCollectionViewLayoutBubblePadding: CGFloat = 20.0
let BubblesCollectionViewLayoutBubbleAddKind = "Add"

class BubblesCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: - Privates
    
    private var count = 0
    private var center = CGPointZero
    private var radius: CGFloat = 0.0
    
    private var deleteIndexPaths = [NSIndexPath]()
    private var insertIndexPaths = [NSIndexPath]()
    
    // MARK: - UICollectionViewLayout
    
    override func prepareLayout() {
        super.prepareLayout()
        
        let size = self.collectionView?.frame.size ?? CGSizeZero
        center = CGPointMake(size.width / 2.0, size.height / 2.0)
        radius = min(size.width, size.height) / 3.0
        count = self.collectionView?.numberOfItemsInSection(0) ?? 0
    }
    
    override func collectionViewContentSize() -> CGSize {
        return self.collectionView?.frame.size ?? CGSizeZero
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.size = calculateItemSize()
        attributes.center = calculateItemCenter(indexPath: indexPath)
        
        return attributes
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [AnyObject]!) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        deleteIndexPaths = [NSIndexPath]()
        insertIndexPaths = [NSIndexPath]()
        
        for update in updateItems {
            if update.updateAction == UICollectionUpdateAction.Delete {
                deleteIndexPaths.append(update.indexPathBeforeUpdate)
            } else if update.updateAction == UICollectionUpdateAction.Insert {
                insertIndexPaths.append(update.indexPathAfterUpdate)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        deleteIndexPaths = [NSIndexPath]()
        insertIndexPaths = [NSIndexPath]()
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Add supplementary add bubble.
        layoutAttributes.append(self.layoutAttributesForSupplementaryViewOfKind(BubblesCollectionViewLayoutBubbleAddKind, atIndexPath: NSIndexPath(forItem: count, inSection: 0)))
        
        // Add team bubbles.
        for index in 0..<count {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            layoutAttributes.append(self.layoutAttributesForItemAtIndexPath(indexPath))
        }
        
        return layoutAttributes
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
        
        attributes.size = CGSizeMake(BubblesCollectionViewLayoutBubbleAddSize, BubblesCollectionViewLayoutBubbleAddSize)
        attributes.center = calculateSupplementaryViewCenter()
        
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        
        if let found = find(insertIndexPaths, itemIndexPath) {
            if attributes == nil {
                attributes = self.layoutAttributesForItemAtIndexPath(itemIndexPath)
            }
            attributes?.alpha = 1.0
            attributes?.transform = CGAffineTransformMakeScale(0.001, 0.001)
            attributes?.center = calculateSupplementaryViewCenter()
        }
        
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        
        if let found = find(deleteIndexPaths, itemIndexPath) {
            if attributes == nil {
                attributes = self.layoutAttributesForItemAtIndexPath(itemIndexPath)
            }
            attributes?.alpha = 1.0
            attributes?.transform = CGAffineTransformMakeScale(0.001, 0.001)
            attributes?.center = calculateSupplementaryViewCenter()
        }

        return attributes
    }
    
    // MARK: - Calculations
    
    private func calculateSupplementaryViewCenter() -> CGPoint {
        if count == 0 || count > 3 {
            return center
        } else {
            let collectionViewSize = self.collectionView?.frame.size ?? CGSizeZero
            let x = collectionViewSize.width - BubblesCollectionViewLayoutBubbleAddSize - BubblesCollectionViewLayoutBubblePadding
            let y = collectionViewSize.width - BubblesCollectionViewLayoutBubbleAddSize - BubblesCollectionViewLayoutBubblePadding
            return CGPointMake(x, y)
        }
    }
    
    private func calculateItemCenter(#indexPath: NSIndexPath) -> CGPoint {
        if count > 3 {
            let xRatio = cosf(Float(2.0 * CGFloat(indexPath.item) * CGFloat(M_PI) / CGFloat(count)))
            let x = CGFloat(center.x) + radius * CGFloat(xRatio)
            let yRatio = sinf(Float(2.0 * CGFloat(indexPath.item) * CGFloat(M_PI) / CGFloat(count)))
            let y = CGFloat(center.y) + radius * CGFloat(yRatio)
            return CGPointMake(x, y)
        } else {
            var x = center.x
            var y = center.y
            var ratio: CGFloat = count == 2 ? 2.0 : 1.0
            if indexPath.item == 0 && count == 2 {
                x += calculateItemSize().width / ratio
                y -= calculateItemSize().height / ratio
            } else if indexPath.item == 1 {
                x -= calculateItemSize().width / ratio
                y += calculateItemSize().height / ratio
            } else if indexPath.item == 2 {
                x += calculateItemSize().width / ratio
                y -= calculateItemSize().height / ratio
            }
            return CGPointMake(x, y)
        }
    }
    
    private func calculateItemSize() -> CGSize {
        let collectionViewSize = self.collectionView?.frame.size ?? CGSizeZero
        let ratio: CGFloat = count < 3 ? 3.5 : 4.0
        let size =  CGFloat(collectionViewSize.width / ratio)
        return CGSizeMake(size, size)
    }
    
}
