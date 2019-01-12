//
//  HistoryViewController.swift
//  Dopplerr
//
//  Created by Eric Castillo on 1/5/19.
//  Copyright © 2019 Eric Castillo. All rights reserved.
//

import UIKit
import SwiftSonarr

class HistoryViewController: UIViewController {
    
    var allSeries = [Series]()
    var history: History?
    var historyEpisodes = [Episode]()
    var dispatchGroup = DispatchGroup()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "SonarrTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "episodeCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300

        refreshView()
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
    
    func loadHistory() {
        dispatchGroup.enter()
        Sonarr.history(sortKey: nil) { (result) in
            switch result {
            case .success(let history):
                self.history = history
            case .failure(let error as NSError):
                print(error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    func refreshView() {
        loadSeries()
        loadHistory()
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("dispatched")
            let historyEpisodeIds = self.history?.records.map { $0.episodeId! }
            Sonarr.episodes(ids: historyEpisodeIds!, { result in
                switch result {
                case .success(let episodes):
                    self.historyEpisodes = episodes
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case.failure(let error):
                    print(error)
                }
            })
        }
    }

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history?.records.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath) as! SonarrTableViewCell
        
        let record = history!.records[indexPath.row]
        let episode = historyEpisodes.filter { $0.id == record.episodeId }.first!
        let series = allSeries.filter { $0.id == record.seriesId }.first!
        
        cell.primaryTextLabel?.text = series.title
        cell.secondaryTextLabel?.text = "\(episode.seasonNumber!)x\(episode.episodeNumber!): \(episode.title!)"
        
        if indexPath.row == 2 {
            cell.downloadProgress = 0.2
            cell.status = .downloading
        } else {
            cell.downloadProgress = nil
            cell.status = .error
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        let detail1 = SSTableViewCellDetailView()
        detail1.keyLabel.text = "Date"
        detail1.valueLabel.text = dateFormatter.string(from: record.date!)
        
        let detail2 = SSTableViewCellDetailView()
        detail2.keyLabel.text = "Quality"
        detail2.valueLabel.text = record.quality?.quality.name
        
        cell.detailStackViews = [detail1, detail2]
        
        return cell
    }
}
