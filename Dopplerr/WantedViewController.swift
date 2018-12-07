//
//  WantedViewController.swift
//  Dopplerr
//
//  Created by Eric Castillo on 11/22/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import SwiftSonarr
import Kingfisher

class WantedViewController: UIViewController {
    
    var allSeries: [Series]?
    var episodes: [Episode]?
    var queue: [QueueItem]?
    let dispatchGroup = DispatchGroup()
    
    let test = Bundle.main.loadNibNamed(String(describing: SeriesCollectionViewCell.self), owner: nil, options: nil)![0] as! SeriesCollectionViewCell

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func clickButton(_ sender: ToggleButton) {
        print("clicked button")
        sender.isSelected = !sender.isSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadEpisodes()
        //loadQueue()
        loadSeries()
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("dispatched")
            self.collectionView.reloadData()
        }
        
        let nibName = UINib(nibName: "SeriesCollectionViewCell", bundle:nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "seriesCell")

        let layout =  UICollectionViewFlowLayout()
        //layout.headerReferenceSize = CGSize(width: 0, height: 50)
        collectionView.collectionViewLayout = layout
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
    
    func loadEpisodes() {
        dispatchGroup.enter()
        Sonarr.wantedMissing(options: nil) { (result) in
            switch result {
            case .success(let wantedMissing):
                self.episodes = wantedMissing.records
            case.failure(let error):
                print(error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    func loadQueue() {
        dispatchGroup.enter()
        Sonarr.queue { (result) in
            switch result {
            case .success(let queue):
                self.queue = queue
            case .failure(let error as NSError):
                print(error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    
    func status(episode: Episode) -> String {
        if let episodeInQueue = queue?.first(where: { $0.id == episode.id }) {
            let progress = 100 - (episodeInQueue.sizeleft! / episodeInQueue.size! * 100)
            if progress == 0 {
                // episode is downloading
                return "ep is downloading"
            } else {
                // episode is downloading - xx%
                return "ep is downloading - \(progress)%"
            }
        } else if let airDateUtc = episode.airDateUtc {
            if airDateUtc <= Date() {
                // episode is missing from disk
                return "ep is missing from disk"
            }
        } else {
            // TBA
            return "TBA"
        }
        return ""
    }
}

extension WantedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of series found: \(allSeries?.count)")
        return allSeries?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seriesCell", for: indexPath) as! SeriesCollectionViewCell
        
        let imageUrl = allSeries?[indexPath.row].images?[0].url
            
        //let url = URL(string: imageUrl!)
        //let url = URL(string: imageUrl!, relativeTo: URL(string: "192.168.1.15:8989")!)
        let url = URLComponents(string: "http://192.168.1.15:8989"+imageUrl!)?.url!
        print(url?.absoluteString)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    cell.image.image = UIImage(data: data)
                }
                print(url?.absoluteString)
            }
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "test", for: indexPath)
//        return headerView
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let cell = Bundle.main.loadNibNamed(String(describing: SeriesCollectionViewCell.self), owner: nil, options: nil)![0] as! SeriesCollectionViewCell
        let collectionWidth: CGFloat = collectionView.frame.width
        let itemSpacing: CGFloat = 16
        let itemsInOneLine = 3
        let width = collectionWidth - itemSpacing * CGFloat(itemsInOneLine - 1)
        test.frame.size.width = floor(width/CGFloat(3))
        let resizing = test.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        
        return resizing
    }
}

extension WantedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
        
        let episodeTitle = episodes![indexPath.row].title
        let episodeSeries = episodes![indexPath.row].series?.title
        
        cell.textLabel?.text = episodeSeries! + ": " + episodeTitle!
        cell.detailTextLabel?.text = status(episode: episodes![indexPath.row])
        return cell
    }
}
