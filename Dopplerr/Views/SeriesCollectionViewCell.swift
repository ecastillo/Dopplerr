//
//  SeriesCollectionViewCell.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/3/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class SeriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    
   // private var widthConstraint: NSLayoutConstraint?
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let height = image.frame.height + title.frame.height
//        frame.size.height = height
//    }
    
   // override func awakeFromNib() {
     //   super.awakeFromNib()
        //custom logic goes here
        
//        let collectionWidth: CGFloat = collectionView.frame.width
//        let itemSpacing: CGFloat = 16
//        let itemsInOneLine = 3
//
//        let layout =  UICollectionViewFlowLayout()
//        let width = collectionWidth - itemSpacing * CGFloat(itemsInOneLine - 1)
//        //layout.itemSize = CGSize(width:floor(width/CGFloat(itemsInOneLine)),height:width/CGFloat(itemsInOneLine))
//        layout.itemSize.width = floor(width/CGFloat(itemsInOneLine))

        //widthConstraint = contentView.widthAnchor.constraint(equalTo: superview!.widthAnchor, multiplier: 0.3)
        //updateConstraints()
  //  }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        // Create width constraint to set it later.
//        widthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    override func updateConstraints() {
//        // Set width constraint to superview's width.
//        widthConstraint?.constant = superview?.bounds.width ?? 0
//        widthConstraint?.isActive = true
//        super.updateConstraints()
//    }
}
