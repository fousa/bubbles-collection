//
//  BubbleViewCell.swift
//  Bubbles Collection
//
//  Created by Jelle Vandenbeeck on 07/01/15.
//  Copyright (c) 2015 Fousa. All rights reserved.
//

import UIKit

class BubbleViewCell: UICollectionViewCell {
    
    override var highlighted: Bool {
        didSet {
            toggleTouchAnimation()
        }
    }
    
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
        self.backgroundColor = UIColor.greenColor()
    }
    
    // MARK: - Animation
    
    private func toggleTouchAnimation() {
        UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .CurveEaseInOut, animations: { () -> Void in
            if (self.highlighted) {
                self.transform = CGAffineTransformMakeScale(0.9, 0.9)
            } else {
                self.transform = CGAffineTransformIdentity
            }
        }, completion: nil)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.size.width / 2.0
    }

}
