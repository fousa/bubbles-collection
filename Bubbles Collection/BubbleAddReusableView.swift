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
    
    // MARK: - Privates
    
    private var highlighted = false
    
    // MARK: Public
    
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
    
    // MARK: - Touches
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        toggleTouchAnimation(highlighted: true)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        toggleTouchAnimation(highlighted: false)
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
        toggleTouchAnimation(highlighted: false)
    }
    
    // MARK: - Animation
    
    private func toggleTouchAnimation(#highlighted: Bool) {
        UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .CurveEaseInOut, animations: { () -> Void in
            if (highlighted) {
                self.transform = CGAffineTransformMakeScale(0.9, 0.9)
            } else {
                self.transform = CGAffineTransformIdentity
            }
        }, completion: nil)
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
