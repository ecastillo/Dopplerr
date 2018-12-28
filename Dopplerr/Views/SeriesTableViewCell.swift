//
//  SeriesTableViewCell.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/23/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class SeriesTableViewCell: UITableViewCell {

    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    @IBOutlet weak var episodeRatioLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
