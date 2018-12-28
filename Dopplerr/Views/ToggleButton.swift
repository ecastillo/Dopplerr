//
//  ToggleButtonView.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/3/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

@IBDesignable class ToggleButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
    }

}
