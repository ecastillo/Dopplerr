//
//  SSProgressView.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/26/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class SSProgressView: UIProgressView {
    
    var paused: Bool = false

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = layer.frame.height / 2
        progressTintColor = paused ? UIColor.Theme.warning : UIColor.Theme.primary
    }
    
    func sharedInit() {
        trackTintColor = UIColor.Theme.lightGray
        layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
}
