//
//  AllSeriesViewController.swift
//  Dopplerr
//
//  Created by Eric Castillo on 11/22/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import SwiftSonarr
import Kingfisher
import SwiftR
import ToastSwiftFramework
import NotificationBanner

class AllSeriesViewController: UIViewController {
    
    var allSeries = [Series]()
    var episodes: [Episode]?
    //var queue: [QueueItem]?
    let dispatchGroup = DispatchGroup()
    let filter = SeriesFilter.all
    var displaySeries = [Series]()
    var selectedSeries: Series?
    
    enum SeriesFilter {
        case all
        case monitored
        case continuing
        case ended
        case missing
    }
    
    let test = Bundle.main.loadNibNamed(String(describing: SeriesCollectionViewCell.self), owner: nil, options: nil)![0] as! SeriesCollectionViewCell

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var allButton: ToggleButton!
    @IBOutlet weak var monitoredButton: ToggleButton!
    @IBOutlet weak var continuingButton: ToggleButton!
    @IBOutlet weak var endedButton: ToggleButton!
    @IBOutlet weak var missingButton: ToggleButton!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let filterAlert = UIAlertController(title: "Filter Series", message: nil, preferredStyle: .actionSheet)
        filterAlert.addAction(UIAlertAction(title: "All", style: .default, handler: { action in
            print("action1 tapped")
            self.filterSeries(filter: .all)
            self.filterButton.setTitle("All", for: .normal)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }))
        filterAlert.addAction(UIAlertAction(title: "Monitored", style: .default, handler: { action in
            print("action2 tapped")
            self.filterSeries(filter: .monitored)
            self.filterButton.setTitle("Monitored", for: .normal)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }))
        filterAlert.addAction(UIAlertAction(title: "Continuing", style: .default, handler: { action in
            print("action3 tapped")
            self.filterSeries(filter: .continuing)
            self.filterButton.setTitle("Continuing", for: .normal)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }))
        filterAlert.addAction(UIAlertAction(title: "Ended", style: .default, handler: { action in
            print("action4 tapped")
            self.filterSeries(filter: .ended)
            self.filterButton.setTitle("Ended", for: .normal)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }))
        filterAlert.addAction(UIAlertAction(title: "Missing", style: .default, handler: { action in
            print("action5 tapped")
            self.filterSeries(filter: .missing)
            self.filterButton.setTitle("Missing", for: .normal)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }))
        filterAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("cancel tapped")
        }))
        present(filterAlert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadEpisodes()
        //loadQueue()
        loadSeries()
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("dispatched")
            self.displaySeries = self.allSeries
            self.collectionView.reloadData()
            
//            // toggle queueing behavior
//            ToastManager.shared.isQueueEnabled = true
//            self.view.makeToast("This is a piece of toast")
//
//            // create a new style
//            var style = ToastStyle()
//            // this is just one of many style options
//            style.messageColor = .blue
//            self.view.makeToast("This is a piece of toast2", duration: 3.0, position: .bottom, style: style)
            
//            let q = NotificationBannerQueue()
//            
//            self.banner1 = StatusBarNotificationBanner(title: "banner 1", style: .success)
//            self.banner2 = StatusBarNotificationBanner(title: "banner 2", style: .success)
//            
//            self.banner1!.show(queue: q)
//            self.banner2!.show(queue: q)
            
            
        }
        
        let nibName = UINib(nibName: "SeriesCollectionViewCell", bundle:nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "seriesCell")

        let layout =  UICollectionViewFlowLayout()
        //layout.headerReferenceSize = CGSize(width: 0, height: 50)
        collectionView.collectionViewLayout = layout
        
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        // Hide label of child view controller's back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .default
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
    
    func filterSeries(filter: SeriesFilter) {
        switch filter {
        case .continuing:
            displaySeries = allSeries.filter { $0.status == "continuing" }
        case .monitored:
            displaySeries = allSeries.filter { $0.monitored == true }
        case .ended:
            displaySeries = allSeries.filter { $0.status == "ended" }
        case .missing:
            displaySeries = allSeries.filter { $0.statistics!.episodeFileCount! < $0.statistics!.episodeCount! }
        default:
            displaySeries = allSeries
        }
    }
    
//    func loadEpisodes() {
//        dispatchGroup.enter()
//        Sonarr.wantedMissing(options: nil) { (result) in
//            switch result {
//            case .success(let wantedMissing):
//                self.episodes = wantedMissing.records
//            case.failure(let error):
//                print(error)
//            }
//            self.dispatchGroup.leave()
//        }
//    }
    
//    func loadQueue() {
//        dispatchGroup.enter()
//        Sonarr.queue { (result) in
//            switch result {
//            case .success(let queue):
//                self.queue = queue
//            case .failure(let error as NSError):
//                print(error)
//            }
//            self.dispatchGroup.leave()
//        }
//    }
    
    
//    func status(episode: Episode) -> String {
//        if let episodeInQueue = queue?.first(where: { $0.id == episode.id }) {
//            let progress = 100 - (episodeInQueue.sizeleft! / episodeInQueue.size! * 100)
//            if progress == 0 {
//                // episode is downloading
//                return "ep is downloading"
//            } else {
//                // episode is downloading - xx%
//                return "ep is downloading - \(progress)%"
//            }
//        } else if let airDateUtc = episode.airDateUtc {
//            if airDateUtc <= Date() {
//                // episode is missing from disk
//                return "ep is missing from disk"
//            }
//        } else {
//            // TBA
//            return "TBA"
//        }
//        return ""
//    }
}

extension AllSeriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of series found: \(allSeries.count)")
        return displaySeries.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seriesCell", for: indexPath) as! SeriesCollectionViewCell
        
        let series = displaySeries[indexPath.row]
        if let poster: SeriesImage = (series.images?.compactMap { $0 }.filter { $0.coverType == .poster }.first) {
            let url = URLComponents(string: "http://192.168.1.15:8989"+poster.url!)?.url!
            cell.image.kf.setImage(with: url)
        } else {
            cell.image.image = nil
        }
        cell.title.text = series.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let nextAiring = series.nextAiring {
            let offset = nextAiring.offset(from: Date())
            cell.airDateLabel.text = offset
        } else {
            cell.airDateLabel.text = " "
        }
        
        cell.progressView.progress = Float(series.statistics!.episodeFileCount!) / Float(series.statistics!.episodeCount!)
        if series.status == "ended" {
            cell.progressView.progressTintColor = UIColor.green
        } else if (series.statistics!.episodeFileCount! < series.statistics!.episodeCount!) && series.monitored! {
            cell.progressView.progressTintColor = UIColor.red
        } else if (series.statistics!.episodeFileCount! < series.statistics!.episodeCount!) && !series.monitored! {
            cell.progressView.progressTintColor = UIColor.yellow
        } else {
            cell.progressView.progressTintColor = UIColor.Theme.primary
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let cell = Bundle.main.loadNibNamed(String(describing: SeriesCollectionViewCell.self), owner: nil, options: nil)![0] as! SeriesCollectionViewCell
        let collectionWidth: CGFloat = collectionView.frame.width - (32)
        let itemSpacing: CGFloat = 16
        let itemsInOneLine = 3
        let width = collectionWidth - itemSpacing * CGFloat(itemsInOneLine - 1)
        test.frame.size.width = floor(width/CGFloat(3))
        let resizing = test.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        
        return resizing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSeries = displaySeries[indexPath.row]
        performSegue(withIdentifier: "goToSeriesDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSeriesDetail" {
            let destinationVC = segue.destination as! SeriesViewController
            destinationVC.title = selectedSeries?.title
            destinationVC.series = selectedSeries
        }
    }
}

//extension WantedViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return episodes?.count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
//        
//        let episodeTitle = episodes![indexPath.row].title
//        let episodeSeries = episodes![indexPath.row].series?.title
//        
//        cell.textLabel?.text = episodeSeries! + ": " + episodeTitle!
//        cell.detailTextLabel?.text = status(episode: episodes![indexPath.row])
//        return cell
//    }
//}
