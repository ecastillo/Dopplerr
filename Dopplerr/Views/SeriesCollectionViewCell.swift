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
    @IBOutlet weak var progressView: SSProgressView!
    
    var imageShadow: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        image.layer.cornerRadius = 4
        image.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageShadow == nil {
            imageShadow = CAShapeLayer()
            
            imageShadow.path = UIBezierPath(roundedRect: image.bounds, cornerRadius: 4).cgPath
            imageShadow.fillColor = UIColor.black.cgColor
            
            //imageShadow.shadowColor = UIColor.black.cgColor
            imageShadow.shadowPath = imageShadow.path
            //imageShadow.shadowOffset = CGSize(width: 0, height: 7)
            //imageShadow.shadowOpacity = 0.25
            //imageShadow.shadowRadius = 8
            
            imageShadow.applySketchShadow(color: UIColor.black, alpha: 0.25, x: 0, y: image.layer.bounds.height*0.0324, blur: 8, spread: -4)
            
            layer.insertSublayer(imageShadow, below: image.layer)
        }
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
