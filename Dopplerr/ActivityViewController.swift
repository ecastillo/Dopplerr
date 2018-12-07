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
    
    var queue: [QueueItem]?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadQueue()
        
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
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queue?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell2", for: indexPath)
        
        let item = queue![indexPath.row]
        
        cell.textLabel?.text = item.series!.title! + ": " + item.episode!.title!
        cell.detailTextLabel?.text = String(item.sizeleft!)
        
        return cell
    }
    
    
}
