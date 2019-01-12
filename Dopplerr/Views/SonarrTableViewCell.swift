//
//  SonarrTableViewCell.swift
//  Dopplerr
//
//  Created by Eric Castillo on 1/5/19.
//  Copyright © 2019 Eric Castillo. All rights reserved.
//

import UIKit

class SonarrTableViewCell: UITableViewCell {

    @IBOutlet weak var innerContentView: UIView!
    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusContainerView: UIView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var progressView: SSProgressView!
    @IBOutlet weak var progressPercentLabel: UILabel!
    @IBOutlet weak var progressTimeLabel: UILabel!
    @IBOutlet weak var detailsStackView: UIStackView!
    
    enum Status {
        case downloading
        case paused
        case done
        case queued
        case error
    }
    
    var downloadProgress: Float? {
        didSet {
            progressStackView.isHidden = (downloadProgress == nil)
            
            if let downloadProgress = downloadProgress {
                progressPercentLabel.text = String(format: "%.1f", downloadProgress*100) + "%"
                progressView.setProgress(downloadProgress, animated: false)
                progressView.layoutSublayers(of: self.progressView.layer)
            }
        }
    }
    var downloadTimeRemaining: TimeInterval?
    
    var status: Status? {
        didSet {
            switch status {
            case .downloading?:
                statusContainerView.isHidden = false
                statusContainerView.layer.backgroundColor = UIColor.Theme.primary.withAlphaComponent(0.25).cgColor
                statusImageView.image = #imageLiteral(resourceName: "cloud-download").withRenderingMode(.alwaysTemplate)
                statusImageView.tintColor = UIColor.Theme.primary
                progressView.paused = false
            case .paused?:
                statusContainerView.isHidden = false
                statusContainerView.layer.backgroundColor = UIColor.Theme.warning.withAlphaComponent(0.25).cgColor
                statusImageView.image = #imageLiteral(resourceName: "player-pause").withRenderingMode(.alwaysTemplate)
                statusImageView.tintColor = UIColor.Theme.warning
                progressView.paused = true
            case .done?:
                statusContainerView.isHidden = false
                statusContainerView.layer.backgroundColor = UIColor.Theme.success.withAlphaComponent(0.25).cgColor
                statusImageView.image = #imageLiteral(resourceName: "inbox").withRenderingMode(.alwaysTemplate)
                statusImageView.tintColor = UIColor.Theme.success
            case .queued?:
                statusContainerView.isHidden = false
                statusContainerView.layer.backgroundColor = UIColor.Theme.mediumGray.withAlphaComponent(0.25).cgColor
                statusImageView.image = #imageLiteral(resourceName: "cloud").withRenderingMode(.alwaysTemplate)
                statusImageView.tintColor = UIColor.Theme.mediumGray
            case .error?:
                statusContainerView.isHidden = false
                statusContainerView.layer.backgroundColor = UIColor.Theme.error.withAlphaComponent(0.25).cgColor
                statusImageView.image = #imageLiteral(resourceName: "alert-triangle").withRenderingMode(.alwaysTemplate)
                statusImageView.tintColor = UIColor.Theme.error
            case .none:
                statusContainerView.isHidden = true
            }
        }
    }
    
    var detailStackViews: [SSTableViewCellDetailView]? {
        didSet {
            configureDetailViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        innerContentView.layer.cornerRadius = 7
        
        statusContainerView.layer.cornerRadius = 7
        statusContainerView.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        configureDetailViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func configureDetailViews() {
        detailsStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        if let detailStackViews = detailStackViews, detailStackViews.count > 0 {
            detailsStackView.isHidden = false
            
            for subview in detailStackViews {
                detailsStackView.addArrangedSubview(subview)
            }
        } else {
            detailsStackView.isHidden = true
        }
    }
}
