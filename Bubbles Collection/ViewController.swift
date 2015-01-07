//
//  ViewController.swift
//  Bubbles Collection
//
//  Created by Jelle Vandenbeeck on 07/01/15.
//  Copyright (c) 2015 Fousa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, BubbleAddReusableViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: Private
    
    private var count: Int = 5
    
    // MARK: - Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerClass(BubbleAddReusableView.classForCoder(), forSupplementaryViewOfKind: BubblesCollectionViewLayoutBubbleAddKind, withReuseIdentifier: "Add")
    }
    
    // MARK: - BubbleAddReusableViewDelegate
    
    func bubbleAddShouldAdd(reusableView: BubbleAddReusableView) {
        if count < 6 {
            count++
            self.collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: count - 1, inSection: 0)])
        }
    }
    
    // MARK: - UICollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
        cell.layer.cornerRadius = cell.frame.size.width / 2.0
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Add", forIndexPath: indexPath) as BubbleAddReusableView
        view.delegate = self
        return view
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        count--
        self.collectionView.deleteItemsAtIndexPaths([indexPath])
    }

}

