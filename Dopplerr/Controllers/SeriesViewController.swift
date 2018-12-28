//
//  SeriesViewController.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/13/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import SwiftSonarr

class SeriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageViewTop: NSLayoutConstraint!
    //@IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var seriesTitle: UILabel!
    @IBOutlet weak var headerBackground: UIImageView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerContentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var seriesDescriptionLabel: UILabel!
    
    var originalHeaderViewHeight = CGFloat(0)
    var oldOffset = CGFloat(0)
    
    var maxHeaderHeight = CGFloat(0)
    var minHeaderHeight = CGFloat(0)
    
    var series: Series?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        

        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = headerBackground.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerBackground.insertSubview(blurEffectView, at: 0)
        
        tableView.contentInsetAdjustmentBehavior = .never
        
        print("header content view frame height: \(tableHeaderView.frame.height)")
        
        navigationController?.navigationBar.barStyle = .black
        
        seriesDescriptionLabel.text = series?.overview
        
        if let poster: SeriesImage = (series?.images?.compactMap { $0 }.filter { $0.coverType == .poster }.first) {
            let url = URLComponents(string: "http://192.168.1.15:8989"+poster.url!)?.url!
            self.poster.kf.setImage(with: url)
        } else {
            self.poster.image = nil
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor.white
        seriesTitle.text = series?.title
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        originalHeaderViewHeight = tableHeaderView.frame.height + view.safeAreaInsets.top
        headerViewHeightConstraint.constant = originalHeaderViewHeight
        headerContentViewTopConstraint.constant = view.safeAreaInsets.top
        
        tableView.contentInset.top = originalHeaderViewHeight
        tableView.contentOffset.y = -(originalHeaderViewHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollview content offset y: \(scrollView.contentOffset.y)")
        let offset = scrollView.contentOffset.y
        let defaultTop = CGFloat(0)
        // If we have not scrolled too high then stick to default y pos
        var currentTop = defaultTop
        if offset < 0{ //Whenever we go too high run this code block
            //The new top (y position) of the imageview
            currentTop = offset
        }

        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        let bottomPadding = window?.safeAreaInsets.bottom


        //headerContentViewTopConstraint.constant = originalHeaderViewHeight + view.safeAreaInsets.top

        maxHeaderHeight = originalHeaderViewHeight
        minHeaderHeight = view.safeAreaInsets.top
        
        let scrollProgress = (-tableView.contentOffset.y-view.safeAreaInsets.top)/(maxHeaderHeight - minHeaderHeight)
        print("scroll progress: \(scrollProgress)")
        headerContentView.alpha = scrollProgress
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.init(white: 1, alpha: 1-scrollProgress)]
        
        if tableView.contentOffset.y < -maxHeaderHeight {
            headerViewHeightConstraint.constant = -tableView.contentOffset.y
            headerContentViewTopConstraint.constant = (-tableView.contentOffset.y - maxHeaderHeight)/2 + view.safeAreaInsets.top
        } else if tableView.contentOffset.y >= -maxHeaderHeight && tableView.contentOffset.y < -minHeaderHeight {
            headerViewHeightConstraint.constant = -tableView.contentOffset.y
            headerContentViewTopConstraint.constant = (-tableView.contentOffset.y - maxHeaderHeight)*1.3 + view.safeAreaInsets.top
            print("header content view top constraint: \(headerContentViewTopConstraint.constant)")
        } else {
            headerViewHeightConstraint.constant = minHeaderHeight
        }

        tableView.scrollIndicatorInsets = tableView.contentInset
        view.layoutIfNeeded()

    }
    
    override func willMove(toParent parent: UIViewController?) {
        // For some reason this is needed to set the parent view controller's title properties correctly
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
    }
}


extension SeriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series?.seasons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let season = series?.seasons?[indexPath.row] else {
            fatalError()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "seasonCell", for: indexPath) as! SeriesTableViewCell
        cell.seasonLabel.text = "Season \(season.seasonNumber ?? -1)"
        cell.episodeCountLabel.text = "\(season.statistics?.totalEpisodeCount ?? -1) episodes"
        cell.episodeRatioLabel.text = "\(season.statistics?.episodeFileCount ?? -1)/\(season.statistics?.episodeCount ?? -1)"
        return cell
    }
}
