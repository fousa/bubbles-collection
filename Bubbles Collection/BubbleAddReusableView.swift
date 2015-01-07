//
//  BubbleAddReusableView.swift
//  Bubbles Collection
//
//  Created by Jelle Vandenbeeck on 07/01/15.
//  Copyright (c) 2015 Fousa. All rights reserved.
//

import UIKit

protocol BubbleAddReusableViewDelegate {
    func bubbleAddShouldAdd(reusableView: BubbleAddReusableView)
}

class BubbleAddReusableView: UICollectionReusableView {
    
    // MARK: - Public
    
    var delegate: BubbleAddReusableViewDelegate?
    
    // MARK: Initilization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.redColor()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "add:")
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Gestures
    
    func add(gesture: UITapGestureRecognizer) {
        delegate?.bubbleAddShouldAdd(self)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.size.width / 2.0
    }
    
}
