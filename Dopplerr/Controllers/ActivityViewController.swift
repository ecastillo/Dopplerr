//
//  ActivityViewController.swift
//  Dopplerr
//
//  Created by Eric Castillo on 11/22/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import SwiftSonarr

class ActivityViewController: UIViewController {
    
    var queue = [QueueItem]()
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadQueue()
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshQueue(_:)), for: .valueChanged)
    }

    func loadQueue() {
        Sonarr.queue { (result) in
            switch result {
            case .success(let queue):
                self.queue = queue
            case .failure(let error as NSError):
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func refreshQueue(_ sender: Any) {
        loadQueue()
        refreshControl.endRefreshing()
        //self.activityIndicatorView.stopAnimating()
    }
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableViewCell
        
        let item = queue[indexPath.row]
        
        guard let series = item.series, let episode = item.episode else {
            fatalError()
        }
        cell.seiresTitle.text = series.title!
        if let seasonNumber = episode.seasonNumber, let episodeNumber = episode.episodeNumber, let title = episode.title {
            cell.episodeTitle.text = "\(seasonNumber)x\(episodeNumber): \(title)"
        } else {
            cell.episodeTitle.text = " "
        }
        
        if let sizeleft = item.sizeleft, let size = item.size {
            if sizeleft == 0 {
                cell.progressView.isHidden = true
                cell.progressTime.isHidden = true
            } else {
                cell.progressView.isHidden = false
                cell.progressTime.isHidden = false
                cell.progressView.progress = 1 - Float(sizeleft) / Float(size)
                
                let formatter = DateComponentsFormatter()
                formatter.unitsStyle = .abbreviated
                formatter.includesApproximationPhrase = false
                formatter.includesTimeRemainingPhrase = false
                formatter.allowedUnits = [.hour, .minute, .second]
                
                cell.progressTime.text = formatter.string(from: item.timeleft!)
            }
        } else {
            cell.progressView.progress = 0
        }
        
        switch item.status {
        case "Completed":
            cell.statusIcon.image = UIImage(named: "inbox")
            let origImage = UIImage(named: "inbox");
            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.statusIcon.image = tintedImage
            cell.statusIcon.tintColor = UIColor.yellow
        case "Downloading":
            cell.statusIcon.image = UIImage(named: "cloud-download")
            let origImage = UIImage(named: "cloud-download");
            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.statusIcon.image = tintedImage
            cell.statusIcon.tintColor = UIColor.blue
        case "Paused":
            cell.statusIcon.image = UIImage(named: "player-pause")
            let origImage = UIImage(named: "player-pause");
            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.statusIcon.image = tintedImage
            cell.statusIcon.tintColor = UIColor.gray
        case "Queued":
            cell.statusIcon.image = UIImage(named: "cloud")
            let origImage = UIImage(named: "cloud");
            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.statusIcon.image = tintedImage
            cell.statusIcon.tintColor = UIColor.gray
        case "Warning":
            cell.statusIcon.image = UIImage(named: "alert-triangle")
            let origImage = UIImage(named: "alert-triangle");
            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.statusIcon.image = tintedImage
            cell.statusIcon.tintColor = UIColor.yellow
        default:
            cell.statusIcon.image = nil
        }
        
        return cell
    }
    
    
}
