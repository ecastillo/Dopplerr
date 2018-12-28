//
//  DiskTableViewCell.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/27/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class DiskTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var freeSpaceLabel: UILabel!
    @IBOutlet weak var spaceProgressView: SSProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
