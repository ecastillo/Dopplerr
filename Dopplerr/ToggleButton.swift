//
//  ToggleButtonView.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/3/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

@IBDesignable class ToggleButton: UIButton {

    //@IBOutlet var contentView: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//    
//    private func commonInit() {
//        //Bundle.main.loadNibNamed("ToggleButton", owner: self, options: nil)
////        Bundle(for: ToggleButton.self).loadNibNamed("ToggleButton", owner: self, options: nil)
////        addSubview(contentView)
////        contentView.frame = self.bounds
////        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        
////        contentView.layer.cornerRadius = bounds.size.height / 2
////        contentView.layer.masksToBounds = true
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //updateCornerRadius()
//        contentView.layer.cornerRadius = bounds.size.height / 2
//        contentView.layer.masksToBounds = true
        
        
        
        if isSelected {
            backgroundColor = UIColor(red: 0.19, green: 0.73, blue: 0.95, alpha: 1)
            setTitleColor(UIColor.white, for: .selected)
        } else {
            backgroundColor = UIColor.clear
            setTitleColor(UIColor.black, for: .normal)
        }
        
        contentEdgeInsets = UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
        
        tintColor = UIColor.clear
        
        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
        
        //adjustsImageWhenHighlighted = false
    }
//
//    @IBInspectable var rounded: Bool = false {
//        didSet {
//            updateCornerRadius()
//        }
//    }
//    
//    func updateCornerRadius() {
//        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
//    }

}
