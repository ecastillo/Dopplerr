//
//  ActivityTableViewCell.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/8/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var seiresTitle: UILabel!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        subviews.forEach { subview in
            subview.layer.masksToBounds = true
            subview.layer.cornerRadius = progressView.frame.height / 2.0
        }
    }

}
