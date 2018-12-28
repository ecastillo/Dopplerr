//
//  SSProgressView.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/26/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class SSProgressView: UIProgressView {
    
    override func draw(_ rect: CGRect) {    
        progressTintColor = UIColor.Theme.primary
        trackTintColor = UIColor.Theme.lightGray
        layer.cornerRadius = layer.frame.height / 2
        layer.masksToBounds = true
    }

}
