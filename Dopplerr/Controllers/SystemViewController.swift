//
//  SystemViewController.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/25/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import SwiftSonarr

class SystemViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var disks = [Disk]()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        loadDisks()
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshDisks(_:)), for: .valueChanged)
    }
    
    func loadDisks() {
        Sonarr.diskspace() { (result) in
            switch result {
            case .success(let disks):
                self.disks = disks
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    @objc func refreshDisks(_ sender: Any) {
        loadDisks()
        refreshControl.endRefreshing()
    }
}

extension SystemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diskCell", for: indexPath) as! DiskTableViewCell
        let disk = disks[indexPath.row]
        
        cell.locationLabel.text = disk.path
        cell.nameLabel.text = disk.label
        cell.spaceProgressView.progress = 1 - (Float(disk.freeSpace!)/Float(disk.totalSpace!))
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useAll]
        bcf.countStyle = .binary
        let byteString = bcf.string(fromByteCount: Int64(disk.freeSpace!))
        cell.freeSpaceLabel.text = "\(byteString) free"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Disk Space"
    }
}
