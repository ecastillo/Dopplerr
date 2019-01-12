//
//  SSTableViewCellDetailView.swift
//  Dopplerr
//
//  Created by Eric Castillo on 1/6/19.
//  Copyright © 2019 Eric Castillo. All rights reserved.
//

import UIKit

class SSTableViewCellDetailView: UIStackView {

    @IBOutlet var contentStackView: SSTableViewCellDetailView!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("SSTableViewCellDetailView", owner: self, options: nil)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false;
        contentStackView.frame = frame;
        addSubview(contentStackView);
        NSLayoutConstraint(item: contentStackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentStackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentStackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentStackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        keyLabel.text = keyLabel.text?.uppercased()
    }
    
}
