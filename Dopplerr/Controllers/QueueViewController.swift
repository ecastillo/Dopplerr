//
//  QueueViewController.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/27/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import SwiftSonarr

class QueueViewController: UIViewController {
    
    var allSeries = [Series]()
    var queue: Queue?
    var queueEpisodes = [Episode]()
    let dispatchGroup = DispatchGroup()
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "SonarrTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "queueCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        
        refreshView()
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshQueue(_:)), for: .valueChanged)
    }
    
    func loadSeries() {
        dispatchGroup.enter()
        print("load series entered group")
        Sonarr.series() { (result) in
            switch result {
            case .success(let series):
                self.allSeries = series
            case.failure(let error):
                print(error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    func loadQueue() {
        dispatchGroup.enter()
        print("load queue entered group")
        Sonarr.queue { (result) in
            switch result {
            case .success(let queue):
                self.queue = queue
            case .failure(let error):
                print(error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    func refreshView() {
        loadSeries()
        loadQueue()
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("dispatched")
            let queueEpisodeIds = self.queue?.records.map { $0.episodeId! }
            Sonarr.episodes(ids: queueEpisodeIds!, { result in
                switch result {
                case .success(let episodes):
                    DispatchQueue.main.async {
                        self.queueEpisodes = episodes
                        self.tableView.reloadData()
                    }
                case.failure(let error):
                    print(error)
                }
            })
        }
    }
    
    @objc func refreshQueue(_ sender: Any) {
        refreshView()
        refreshControl.endRefreshing()
        //self.activityIndicatorView.stopAnimating()
    }
}

extension QueueViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queue?.records.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queueCell", for: indexPath) as! SonarrTableViewCell
        
        let item = queue!.records[indexPath.row]
        guard let seriesId = item.seriesId, let episodeId = item.episodeId else {
            fatalError()
        }
        
        let episode = queueEpisodes.filter { $0.id == episodeId }.first! //queueEpisodes[indexPath.row]
        let series = allSeries.filter { $0.id == seriesId }.first!
        
        
        
        
        
        
        cell.primaryTextLabel.text = series.title
        if let seasonNumber = episode.seasonNumber, let episodeNumber = episode.episodeNumber, let title = episode.title {
            cell.secondaryTextLabel.text = "\(seasonNumber)x\(episodeNumber): \(title)"
        } else {
            cell.secondaryTextLabel.text = nil
        }
        
//        if queueRecord == nil {
//            cell.status = .error
//        } else {
//            cell.status = .downloading
//        }
        
        if item.status == "Downloading" || item.status == "Paused", let sizeLeft = item.sizeleft, let size = item.size {
            cell.downloadProgress = 1-(sizeLeft/size)
            
            if item.status == "Downloading" {
                let formatter = DateComponentsFormatter()
                formatter.unitsStyle = .abbreviated
                formatter.includesApproximationPhrase = false
                formatter.includesTimeRemainingPhrase = false
                formatter.allowedUnits = [.hour, .minute, .second]
                
                cell.progressTimeLabel.text = formatter.string(from: item.timeleft!)
            }
            if item.status == "Paused" {
                cell.progressTimeLabel.text = "Paused"
            }
            
        } else {
            cell.downloadProgress = nil
        }
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        let detail1 = SSTableViewCellDetailView()
        detail1.keyLabel.text = "Air Date"
        detail1.valueLabel.text = dateFormatter.string(from: episode.airDate!)
        
        cell.detailStackViews = [detail1]
        
        
        
        
        
        
//
//        cell.seiresTitle.text = series.title
//        if let seasonNumber = episode.seasonNumber, let episodeNumber = episode.episodeNumber, let title = episode.title {
//            cell.episodeTitle.text = "\(seasonNumber)x\(episodeNumber): \(title)"
//        } else {
//            cell.episodeTitle.text = " "
//        }
//
//        if let sizeleft = item.sizeleft, let size = item.size {
//            if sizeleft == 0 {
//                cell.progressView.isHidden = true
//                cell.progressTime.isHidden = true
//            } else {
//                cell.progressView.isHidden = false
//                cell.progressTime.isHidden = false
//                cell.progressView.progress = 1 - Float(sizeleft) / Float(size)
//
//                let formatter = DateComponentsFormatter()
//                formatter.unitsStyle = .abbreviated
//                formatter.includesApproximationPhrase = false
//                formatter.includesTimeRemainingPhrase = false
//                formatter.allowedUnits = [.hour, .minute, .second]
//
//                cell.progressTime.text = formatter.string(from: item.timeleft!)
//            }
//        } else {
//            cell.progressView.progress = 0
//        }
        
        switch item.status {
        case "Completed":
            cell.status = .done
        case "Downloading":
            cell.status = .downloading
        case "Paused":
            cell.status = .paused
        case "Queued":
            cell.status = .queued
//        case "Warning":
//            cell.statusIcon.image = UIImage(named: "alert-triangle")
//            let origImage = UIImage(named: "alert-triangle");
//            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//            cell.statusIcon.image = tintedImage
//            cell.statusIcon.tintColor = UIColor.yellow
        default:
            cell.status = .none
        }
        
        return cell
    }
}
