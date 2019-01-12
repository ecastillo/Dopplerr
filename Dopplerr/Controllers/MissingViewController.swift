//
//  MissingViewController.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/31/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import SwiftSonarr

class MissingViewController: UIViewController {
    
    var allSeries = [Series]()
    var wantedMissing: WantedMissing?
    var wantedMissingQueueRecords: [Queue.Record]?
    let dispatchGroup = DispatchGroup()
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "SonarrTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "missingCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        
        refreshView()
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshQueue(_:)), for: .valueChanged)
    }
    
    func loadSeries() {
        dispatchGroup.enter()
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
    
    func loadWantedMissing() {
        dispatchGroup.enter()
        Sonarr.wantedMissing(options: nil) { (result) in
            switch result {
            case .success(let wantedMissing):
                self.wantedMissing = wantedMissing
            case .failure(let error):
                print(error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    func refreshView() {
        loadSeries()
        loadWantedMissing()
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("dispatched")
            let wantedMissingEpisodeIds = self.wantedMissing?.records?.map { $0.id! }
            Sonarr.queueDetails(episodeIds: wantedMissingEpisodeIds!) { (result) in
                switch result {
                case .success(let queueDetails):
                    self.wantedMissingQueueRecords = queueDetails
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @objc func refreshQueue(_ sender: Any) {
        refreshView()
        refreshControl.endRefreshing()
        //self.activityIndicatorView.stopAnimating()
    }
}

extension MissingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wantedMissing?.records?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "missingCell", for: indexPath) as! SonarrTableViewCell
        
        let episode = wantedMissing!.records![indexPath.row]
        let queueRecord = wantedMissingQueueRecords?.filter { $0.episodeId == episode.id }.first
        let series = allSeries.filter { $0.id == episode.seriesId }.first!
        
        guard let seriesId = episode.seriesId, let episodeId = episode.id else {
            fatalError()
        }
        
        cell.primaryTextLabel.text = series.title
        if let seasonNumber = episode.seasonNumber, let episodeNumber = episode.episodeNumber, let title = episode.title {
            cell.secondaryTextLabel.text = "\(seasonNumber)x\(episodeNumber): \(title)"
        } else {
            cell.secondaryTextLabel.text = nil
        }
        
        if queueRecord == nil {
            cell.status = .error
        } else {
            cell.status = .downloading
        }
        
        if queueRecord?.status == "Downloading" || queueRecord?.status == "Paused", let sizeLeft = queueRecord?.sizeleft, let size = queueRecord?.size {
            cell.downloadProgress = 1-(sizeLeft/size)
            
            if queueRecord?.status == "Downloading" {
                let formatter = DateComponentsFormatter()
                formatter.unitsStyle = .abbreviated
                formatter.includesApproximationPhrase = false
                formatter.includesTimeRemainingPhrase = false
                formatter.allowedUnits = [.hour, .minute, .second]
                
                cell.progressTimeLabel.text = formatter.string(from: queueRecord!.timeleft!)
            }
            if queueRecord?.status == "Paused" {
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
        
        
        
        //cell.detailStackViews = nil
        
//        switch item.status {
//        case "Completed":
//            cell.statusIcon.image = UIImage(named: "inbox")
//            let origImage = UIImage(named: "inbox");
//            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//            cell.statusIcon.image = tintedImage
//            cell.statusIcon.tintColor = UIColor.yellow
//        case "Downloading":
//            cell.statusIcon.image = UIImage(named: "cloud-download")
//            let origImage = UIImage(named: "cloud-download");
//            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//            cell.statusIcon.image = tintedImage
//            cell.statusIcon.tintColor = UIColor.blue
//        case "Paused":
//            cell.statusIcon.image = UIImage(named: "player-pause")
//            let origImage = UIImage(named: "player-pause");
//            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//            cell.statusIcon.image = tintedImage
//            cell.statusIcon.tintColor = UIColor.gray
//        case "Queued":
//            cell.statusIcon.image = UIImage(named: "cloud")
//            let origImage = UIImage(named: "cloud");
//            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//            cell.statusIcon.image = tintedImage
//            cell.statusIcon.tintColor = UIColor.gray
//        case "Warning":
//            cell.statusIcon.image = UIImage(named: "alert-triangle")
//            let origImage = UIImage(named: "alert-triangle");
//            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//            cell.statusIcon.image = tintedImage
//            cell.statusIcon.tintColor = UIColor.yellow
//        default:
//            cell.statusIcon.image = nil
//        }
        
        return cell
    }
}
