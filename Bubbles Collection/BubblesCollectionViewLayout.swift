//
//  BubblesCollectionViewLayout.swift
//  Bubbles Collection
//
//  Created by Jelle Vandenbeeck on 07/01/15.
//  Copyright (c) 2015 Fousa. All rights reserved.
//

import UIKit

let BubblesCollectionViewLayoutBubbleSize: CGFloat = 50.0
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
        radius = min(size.width, size.height) / 2.5
        count = self.collectionView?.numberOfItemsInSection(0) ?? 0
    }
    
    override func collectionViewContentSize() -> CGSize {
        return self.collectionView?.frame.size ?? CGSizeZero
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.size = CGSizeMake(BubblesCollectionViewLayoutBubbleSize, BubblesCollectionViewLayoutBubbleSize)
        
        let xRatio = cosf(Float(2.0 * CGFloat(indexPath.item) * CGFloat(M_PI) / CGFloat(count)))
        let x = CGFloat(center.x) + radius * CGFloat(xRatio)
        let yRatio = sinf(Float(2.0 * CGFloat(indexPath.item) * CGFloat(M_PI) / CGFloat(count)))
        let y = CGFloat(center.y) + radius * CGFloat(yRatio)
        attributes.center = CGPointMake(x, y)
        
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
        
        // Add team bubbles.
        for index in 0..<count {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            layoutAttributes.append(self.layoutAttributesForItemAtIndexPath(indexPath))
        }
        
        // Add supplementary add bubble.
        layoutAttributes.append(self.layoutAttributesForSupplementaryViewOfKind(BubblesCollectionViewLayoutBubbleAddKind, atIndexPath: NSIndexPath(forItem: count, inSection: 0)))
        
        return layoutAttributes
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
        
        attributes.size = CGSizeMake(BubblesCollectionViewLayoutBubbleSize, BubblesCollectionViewLayoutBubbleSize)
        attributes.center = center
        
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        
        if let found = find(insertIndexPaths, itemIndexPath) {
            if attributes == nil {
                attributes = self.layoutAttributesForItemAtIndexPath(itemIndexPath)
            }
            attributes?.alpha = 0.0
            attributes?.center = center
        }
        
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        
        if let found = find(deleteIndexPaths, itemIndexPath) {
            if attributes == nil {
                attributes = self.layoutAttributesForItemAtIndexPath(itemIndexPath)
            }
            attributes?.alpha = 0.0
            attributes?.center = center
        }

        return attributes
    }
    
}
